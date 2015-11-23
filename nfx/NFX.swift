//
//  NFX.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

let nfxVersion = "0.1"

@objc
public class NFX: NSObject
{
    
    // swiftSharedInstance is not accessible from ObjC
    class var swiftSharedInstance: NFX
    {
        struct Singleton
        {
            static let instance = NFX()
        }
        return Singleton.instance
    }
    
    // the sharedInstance class method can be reached from ObjC
    public class func sharedInstance() -> NFX
    {
        return NFX.swiftSharedInstance
    }
    
    var started: Bool = false
    var presented: Bool = false
    
    @objc public func start()
    {
        self.started = true
        NSURLProtocol.registerClass(NFXProtocol)
        print("netfox \(nfxVersion) - [https://github.com/kasketis/netfox]: Started!")
        clearOldData()
    }
    
    func motionDetected()
    {
        if self.started {
            if self.presented {
                hide()
            } else {
                show()
            }
        }
    }
    
    func show()
    {
        var navigationController: UINavigationController?

        if #available(iOS 8.0, *) {
            var listController: NFXListController
            listController = NFXListController()

            navigationController = UINavigationController(rootViewController: listController)
            navigationController!.navigationBar.translucent = false
            navigationController!.navigationBar.tintColor = UIColor.init(netHex: 0xec5e28)
            navigationController!.navigationBar.barTintColor = UIColor.init(netHex: 0xccc5b9)
            navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(netHex: 0xec5e28)]
            
            let appDelegate = UIApplication.sharedApplication().delegate
            appDelegate!.window?!.rootViewController?.presentViewController(navigationController!, animated: true, completion: { () -> Void in
                self.presented = true
            })
        } else {
            // Fallback on earlier versions
            print("netfox \(nfxVersion) needs iOS >= 8.0!")

        }


    }
    
    func hide()
    {
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate!.window?!.rootViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.presented = false
        })
    }
    
    func clearOldData()
    {
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first!
            let filePathsArray = try NSFileManager.defaultManager().subpathsOfDirectoryAtPath(documentsPath)
            for filePath in filePathsArray {
                if filePath.hasPrefix("nfx") {
                    try NSFileManager.defaultManager().removeItemAtPath((documentsPath as NSString).stringByAppendingPathComponent(filePath))
                }
            }
            
        } catch {}
    }
    
}