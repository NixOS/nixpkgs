import Foundation

@objc public enum UserConfirmation: UInt {
    case send = 0
    case dontSend = 1
    case always = 2
}

@objc public class ErrorReport: NSObject {}

@objc public class ErrorAttachmentLog: NSObject {
    @objc public class func attachment(withText text: String, filename: String) -> ErrorAttachmentLog? {
        return ErrorAttachmentLog()
    }
}

@objc public protocol CrashesDelegate: NSObjectProtocol {
    @objc optional func attachments(with crashes: Crashes, for errorReport: ErrorReport) -> [ErrorAttachmentLog]?
}

@objc public class Crashes: NSObject {
    @objc public static weak var delegate: CrashesDelegate?
    @objc public static var userConfirmationHandler: (([ErrorReport]) -> Bool)?
    @objc public static func notify(with confirmation: UserConfirmation) {}
}
