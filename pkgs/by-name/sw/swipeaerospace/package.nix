{
  actool,
  darwin,
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
  swift,
}:

let
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
        -target ${stdenv.hostPlatform.darwinArch}-apple-macosx13.5 \
        -O \
        -swift-version 5 \
        -emit-library \
        -emit-module \
        -module-name Socket \
        -emit-module-path "$buildDir/Socket.swiftmodule" \
        -Xlinker -install_name -Xlinker "$out/lib/libSocket.dylib" \
        Sources/Socket/*.swift \
        -o "$buildDir/libSocket.dylib"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/swift/macosx"
      cp build/libSocket.dylib "$out/lib"
      cp build/Socket.* "$out/lib/swift/macosx"

      runHook postInstall
    '';
  });

  tomlKit = stdenv.mkDerivation (finalAttrs: {
    pname = "tomlkit";
    version = "0.5.6";

    src = fetchFromGitHub {
      owner = "LebJe";
      repo = "TOMLKit";
      tag = finalAttrs.version;
      hash = "sha256-vQkGqOjBi6WYOSeA7r5w/E6YzPWMHJz2hIYMLrsFums=";
    };

    strictDeps = true;
    __structuredAttrs = true;
    nativeBuildInputs = [
      swift
      darwin.autoSignDarwinBinariesHook
    ];
    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      mkdir -p build
      for source in Sources/CTOML/Sources/*.cpp; do
        $CXX -O2 -std=c++17 -mmacosx-version-min=13.5 -DTOML_EXCEPTIONS=1 -I Sources/CTOML/include \
          -c "$source" -o "build/$(basename "$source" .cpp).o"
      done

      swiftFiles=()
      while IFS= read -r -d "" f; do
        swiftFiles+=("$f")
      done < <(find Sources/TOMLKit -name '*.swift' -print0)

      swiftc -O -swift-version 5 -emit-library -emit-module \
        -target ${stdenv.hostPlatform.darwinArch}-apple-macosx13.5 \
        -module-name TOMLKit -emit-module-path build/TOMLKit.swiftmodule \
        -I Sources/CTOML/include \
        -Xlinker -install_name -Xlinker "$out/lib/libTOMLKit.dylib" \
        "''${swiftFiles[@]}" build/*.o -lc++ -o build/libTOMLKit.dylib

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/swift/macosx" "$out/include"
      cp build/libTOMLKit.dylib "$out/lib"
      cp build/TOMLKit.* "$out/lib/swift/macosx"
      cp -R Sources/CTOML/include/CTOML "$out/include"

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
      CFBundleVersion = "25";
      LSApplicationCategoryType = "public.app-category.developer-tools";
      LSMinimumSystemVersion = "13.5";
      LSUIElement = true;
      NSHumanReadableCopyright = "©Tricster";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "swipeaerospace";
  version = "0.4.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MediosZ";
    repo = "SwipeAeroSpace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CfdoHNE/lJ9md0Xm6Pio9P3coTgQtEoIwZ/uOeHeEgI=";
  };

  nativeBuildInputs = [
    swift
    actool
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = [
    blueSocket
    tomlKit
  ];

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
      -target ${stdenv.hostPlatform.darwinArch}-apple-macosx13.5 \
      -I${lib.getDev blueSocket}/lib/swift/${stdenv.hostPlatform.swift.platform} \
      -I${tomlKit}/lib/swift/${stdenv.hostPlatform.swift.platform} \
      -I${tomlKit}/include \
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
      -lTOMLKit \
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
