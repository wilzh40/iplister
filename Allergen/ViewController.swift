//
//  ViewController.swift
//  Allergen
//
//  Created by Wilson Zhao on 6/27/15.
//  Copyright (c) 2015 Innogen. All rights reserved.
//

import UIKit

import GBPing



class ViewController: UIViewController, GBPingDelegate, ScanLANDelegate {

    var ping: GBPing!
    var scanner: ScanLAN!
    var devices = [Device]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ping = GBPing()
        ping.host = "127.0.0.1"
        ping.delegate = self
        ping.timeout = 1
        ping.pingPeriod = 0.9

        ping.setupWithBlock({ success, error in
            if success {
                self.ping.startPinging()
                let ns = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("stopPing"), userInfo: nil, repeats: false)
                
            }
            
        })
        println("Simple IP" + SimplePing().macaddress())
        println(SimplePing().ip2mac(23))
        
        
        // Scanner
        scanner = ScanLAN(delegate: self)
        scanner.startScan()
        
        
        
        
    }

    func stopPing() {
        self.ping.stop()
        self.ping = nil
    }
    
    func ping(pinger: GBPing!, didFailToSendPingWithSummary summary: GBPingSummary!, error: NSError!) {
        println("FFSENT> \(summary) \(error)")
    }
    
    func ping(pinger: GBPing!, didFailWithError error: NSError!) {
        println("FAIL> \(error)")
    }
    
    func ping(pinger: GBPing!, didReceiveReplyWithSummary summary: GBPingSummary!) {
        println("REPLY> \(summary)")
     }
    
    func ping(pinger: GBPing!, didReceiveUnexpectedReplyWithSummary summary: GBPingSummary!) {
        println("RREPLY> \(summary)")

    }
    
    func ping(pinger: GBPing!, didSendPingWithSummary summary: GBPingSummary!) {
        println("SENT> \(summary)")

    }
    
    func ping(pinger: GBPing!, didTimeoutWithSummary summary: GBPingSummary!) {
        println("TIMEOUT> \(summary)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func scanLANDidFindNewAdrress(address: String!, havingHostName hostName: String!) {
        println("Found \(address) at \(hostName)")
        let d = Device()
        d.address = address
        d.host = hostName
        devices.append(d)
        
    }
    func scanLANDidFinishScanning() {
        for d in devices {
           
            // Turn arr into an array of chars
            //var address = [Int8](count:)
            let mac = SimplePing().ip2mac(inet_addr(d.address!.UTF8String))

            
            
            
            
             println(d.address! as String + " " + mac)
        }
    }

}

