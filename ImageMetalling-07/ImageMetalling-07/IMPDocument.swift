//
//  IMPDocument.swift
//  ImageMetalling-07
//
//  Created by denis svinarchuk on 15.12.15.
//  Copyright © 2015 IMetalling. All rights reserved.
//

import Cocoa
import IMProcessing

enum IMPDocumentType{
    case Image
}

typealias IMPDocumentObserver = ((file:String, type:IMPDocumentType) -> Void)

class IMPDocument: NSObject {
    
    private override init() {}
    private var didUpdateDocumnetHandlers = [IMPDocumentObserver]()
    
    static let sharedInstance = IMPDocument()
    
    var currentFile:String?{
        didSet{
            for o in self.didUpdateDocumnetHandlers{
                o(file: currentFile!, type: .Image)
            }
        }
    }
        
    func addDocumentObserver(observer:IMPDocumentObserver){
        didUpdateDocumnetHandlers.append(observer)
    }    
    
    var filter:IMPTestFilter?
    
    func saveCurrent(filename:String){
        if let cf = currentFile{
            
            if let filter = self.filter {
    
                let resultilter = IMPTestFilter(context: IMPContext())
                resultilter.hsvFilter.adjustment = filter.hsvFilter.adjustment
                resultilter.hsvFilter.overlap = filter.hsvFilter.overlap
                
                do{
                    resultilter.source = try IMPJpegProvider(context: resultilter.context, file: cf)
                    try resultilter.destination?.writeToJpeg(filename, compression: 1)
                }
                catch let error as NSError {
                    
                    let alert = NSAlert(error: error)
                    alert.runModal()
                    
                }
            }
        }
    }
    
}

