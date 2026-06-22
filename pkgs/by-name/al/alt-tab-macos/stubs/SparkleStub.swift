import Foundation
import AppKit

@objc public protocol SPUUpdaterDelegate: NSObjectProtocol {}

@objc public class SUAppcastItem: NSObject {
    @objc public var displayVersionString: String

    @objc public init(displayVersionString: String = "") {
        self.displayVersionString = displayVersionString
    }
}

@objc public class SPUUpdater: NSObject {
    @objc public var automaticallyDownloadsUpdates: Bool = false
    @objc public var automaticallyChecksForUpdates: Bool = false
    @objc public var sessionInProgress: Bool = false
    @objc public func checkForUpdateInformation() {}
}

@objc public class SPUStandardUpdaterController: NSObject {
    @objc public let updater = SPUUpdater()

    @objc public init(startingUpdater: Bool, updaterDelegate: SPUUpdaterDelegate?, userDriverDelegate: Any?) {}
    @objc public func startUpdater() {}
    @objc public func checkForUpdates(_ sender: Any?) {}
}

@objc public class SUUpdater: NSObject {
    private static let instance = SUUpdater()
    @objc public class func shared() -> SUUpdater { return instance }
    @objc public var automaticallyDownloadsUpdates: Bool = false
    @objc public var automaticallyChecksForUpdates: Bool = false
    @objc public func checkForUpdates(_ sender: Any?) {}
}
