import Foundation
import AppKit

@objc public class SUUpdater: NSObject {
    private static let instance = SUUpdater()
    @objc public class func shared() -> SUUpdater { return instance }
    @objc public var automaticallyDownloadsUpdates: Bool = false
    @objc public var automaticallyChecksForUpdates: Bool = false
    @objc public func checkForUpdates(_ sender: Any?) {}
}
