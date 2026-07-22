import Foundation
import AppKit

@objc public protocol SPUUpdaterDelegate: NSObjectProtocol {
    @objc optional func updaterDidNotFindUpdate(_ updater: SPUUpdater)
}

@objc public class SUAppcastItem: NSObject {
    @objc public var displayVersionString: String

    @objc public init(displayVersionString: String = "") {
        self.displayVersionString = displayVersionString
    }
}

@objc public class SPUUpdater: NSObject {
    private weak var delegate: SPUUpdaterDelegate?
    @objc public var automaticallyDownloadsUpdates: Bool = false
    @objc public var automaticallyChecksForUpdates: Bool = false
    @objc public var sessionInProgress: Bool = false

    @objc public init(delegate: SPUUpdaterDelegate? = nil) {
        self.delegate = delegate
    }

    @objc public func checkForUpdateInformation() {
        delegate?.updaterDidNotFindUpdate?(self)
    }
}

@objc public class SPUStandardUpdaterController: NSObject {
    @objc public let updater: SPUUpdater

    @objc public init(startingUpdater: Bool, updaterDelegate: SPUUpdaterDelegate?, userDriverDelegate: Any?) {
        updater = SPUUpdater(delegate: updaterDelegate)
    }
    @objc public func startUpdater() {}
    @objc public func checkForUpdates(_ sender: Any?) {
        updater.checkForUpdateInformation()
        showNixUpdateMessage()
    }
}

@objc public class SUUpdater: NSObject {
    private static let instance = SUUpdater()
    @objc public class func shared() -> SUUpdater { return instance }
    @objc public var automaticallyDownloadsUpdates: Bool = false
    @objc public var automaticallyChecksForUpdates: Bool = false
    @objc public func checkForUpdates(_ sender: Any?) {
        showNixUpdateMessage()
    }
}

private func showNixUpdateMessage() {
    let alert = NSAlert()
    alert.messageText = "Updates are managed by Nix"
    alert.informativeText = "Update AltTab through the Nix profile or system configuration that installed it."
    alert.runModal()
}
