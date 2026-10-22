import Foundation
import AppKit

public protocol SPUStandardUserDriverDelegate: AnyObject {}

public class SUAppcastItem: NSObject {}

public class SPUUpdater: NSObject {
    @objc dynamic public var automaticallyChecksForUpdates: Bool = false
}

public class SPUStandardUpdaterController: NSObject {
    public let updater = SPUUpdater()
    public init(updaterDelegate: Any?, userDriverDelegate: Any?) {}
    @objc public func checkForUpdates(_ sender: Any?) {}
}
