{
  actool,
  darwin,
  fetchFromGitHub,
  lib,
  nix-update-script,
  swiftPackages,
}:

let
  inherit (swiftPackages) stdenv swift;

  blueSocket = stdenv.mkDerivation (finalAttrs: {
    pname = "blue-socket";
    version = "2.0.4";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "Kitura";
      repo = "BlueSocket";
      tag = finalAttrs.version;
      hash = "sha256-Bru14uTGvmAeRLjbFYhWKfRjQcj5cZzp9jzyg5o7EHs=";
    };

    nativeBuildInputs = [
      swift
      darwin.autoSignDarwinBinariesHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      buildDir="$PWD/build"
      mkdir -p "$buildDir"

      swiftc \
        -O \
        -swift-version 5 \
        -emit-library \
        -emit-module \
        -module-name Socket \
        -emit-module-path "$buildDir/Socket.swiftmodule" \
        -Xlinker -install_name -Xlinker "$out/lib/swift/libSocket.dylib" \
        Sources/Socket/*.swift \
        -o "$buildDir/libSocket.dylib"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/swift"
      cp build/libSocket.dylib "$out/lib/swift/"
      cp build/Socket.* "$out/lib/swift/"

      runHook postInstall
    '';
  });

  infoPlist =
    version:
    lib.generators.toPlist { escape = true; } {
      CFBundleDevelopmentRegion = "en";
      CFBundleDisplayName = "SwipeAeroSpace";
      CFBundleExecutable = "SwipeAeroSpace";
      CFBundleIconFile = "AppIcon";
      CFBundleIconName = "AppIcon";
      CFBundleIdentifier = "club.mediosz.SwipeAeroSpace";
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundleName = "SwipeAeroSpace";
      CFBundlePackageType = "APPL";
      CFBundleShortVersionString = version;
      CFBundleSupportedPlatforms = [ "MacOSX" ];
      CFBundleVersion = "18";
      LSApplicationCategoryType = "public.app-category.developer-tools";
      LSMinimumSystemVersion = "13.5";
      LSUIElement = true;
      NSHumanReadableCopyright = "©Tricster";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "swipeaerospace";
  version = "0.3.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MediosZ";
    repo = "SwipeAeroSpace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-468QGWjbRtA9Fml6jjeJZBTCUEp227cQPckqwyLK0dM=";
  };

  # Keep SettingsView unchanged, but open it through a regular WindowGroup.
  # @Environment(\.openSettings) does not compile with nixpkgs' SwiftUI SDK.
  patches = [ ./settings-window.patch ];

  nativeBuildInputs = [
    swift
    actool
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = [ blueSocket ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    buildDir="$PWD/build"
    mkdir -p "$buildDir"

    swiftFiles=()
    while IFS= read -r -d "" f; do
      swiftFiles+=("$f")
    done < <(find SwipeAeroSpace -name '*.swift' -print0)

    swiftc \
      -O \
      -swift-version 5 \
      -parse-as-library \
      -module-name SwipeAeroSpace \
      -Xlinker -platform_version -Xlinker macos -Xlinker 13.5 -Xlinker 26.0 \
      -framework AppKit \
      -framework Cocoa \
      -framework SwiftUI \
      -framework ServiceManagement \
      -lSocket \
      "''${swiftFiles[@]}" \
      -o "$buildDir/SwipeAeroSpace"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    app="$out/Applications/SwipeAeroSpace.app"
    mkdir -p "$app/Contents/"{MacOS,Resources}

    cp build/SwipeAeroSpace "$app/Contents/MacOS/SwipeAeroSpace"
    printf '%s' ${lib.escapeShellArg (infoPlist finalAttrs.version)} > "$app/Contents/Info.plist"
    printf 'APPL????' > "$app/Contents/PkgInfo"

    actool --compile "$app/Contents/Resources" \
      --platform macosx \
      --minimum-deployment-target 13.5 \
      --app-icon AppIcon \
      --output-partial-info-plist /dev/null \
      SwipeAeroSpace/Assets.xcassets

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Switch AeroSpace workspaces by swiping";
    homepage = "https://github.com/MediosZ/SwipeAeroSpace";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kinnrai ];
    platforms = lib.platforms.darwin;
  };
})
