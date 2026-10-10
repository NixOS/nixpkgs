// swift-tools-version: 5.9
import PackageDescription

// Upstream only defines tests; this manifest builds the app without Xcode.
let package = Package(
    name: "SwipeAeroSpace",
    platforms: [.macOS("13.5")],
    products: [
        .executable(name: "SwipeAeroSpace", targets: ["SwipeAeroSpace"]),
    ],
    dependencies: [
        .package(url: "https://github.com/LebJe/TOMLKit.git", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/Kitura/BlueSocket.git", from: "2.0.4"),
    ],
    targets: [
        .executableTarget(
            name: "SwipeAeroSpace",
            dependencies: [
                .product(name: "Socket", package: "BlueSocket"),
                .product(name: "TOMLKit", package: "TOMLKit"),
            ],
            path: "SwipeAeroSpace",
            exclude: ["Assets.xcassets", "Preview Content", "SwipeAeroSpace.entitlements"]
        ),
    ]
)
