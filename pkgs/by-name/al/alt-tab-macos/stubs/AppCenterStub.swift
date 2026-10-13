import Foundation

@objc public class AppCenter: NSObject {
    @objc public static var networkRequestsAllowed: Bool = false
    @objc public static func start(withAppSecret appSecret: String, services: [AnyClass]) {}
}
