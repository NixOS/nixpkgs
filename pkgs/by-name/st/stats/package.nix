{
  lib,
  swiftPackages,
  fetchFromGitHub,
  darwin,
  leveldb,
  perl,
  actool,
  makeWrapper,
  nix-update-script,
}:

let
  inherit (swiftPackages) stdenv swift;

  frameworks = [
    "Kit"
    "CPU"
    "GPU"
    "RAM"
    "Disk"
    "Net"
    "Battery"
    "Bluetooth"
    "Sensors"
    "Clock"
  ];
  modules = lib.tail frameworks;

  toPlist = lib.generators.toPlist { escape = true; };

  frameworkPlist =
    name:
    toPlist {
      CFBundleExecutable = name;
      CFBundleIdentifier = "eu.exelban.Stats.${name}";
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundleName = name;
      CFBundlePackageType = "FMWK";
      CFBundleVersion = "1";
    };

  mainInfoPlist =
    version:
    toPlist {
      CFBundleDevelopmentRegion = "en";
      CFBundleExecutable = "Stats";
      CFBundleIdentifier = "eu.exelban.Stats";
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundleName = "Stats";
      CFBundlePackageType = "APPL";
      CFBundleShortVersionString = version;
      # CFBundleVersion is extracted from upstream's Info.plist at build time
      Description = "Simple macOS system monitor in your menu bar";
      LSApplicationCategoryType = "public.app-category.utilities";
      LSMinimumSystemVersion = "11.0";
      LSUIElement = true;
      NSAppTransportSecurity = {
        NSAllowsArbitraryLoads = true;
      };
      NSBluetoothAlwaysUsageDescription = "This permission allows obtaining battery level of Bluetooth devices";
      NSHumanReadableCopyright = "Copyright © 2020 Serhiy Mytrovtsiy. All rights reserved.";
      NSPrincipalClass = "NSApplication";
      NSUserNotificationAlertStyle = "alert";
      TeamId = "RP2S87B72W";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stats";
  version = "2.12.7";

  src = fetchFromGitHub {
    owner = "exelban";
    repo = "Stats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qx4FI+MnFknIrTOPP+8wyy1wqFMWyaunmags023ay6A=";
  };

  nativeBuildInputs = [
    swift
    perl
    actool
    darwin.autoSignDarwinBinariesHook
    makeWrapper
  ];

  buildInputs = [ leveldb ];

  # Stats uses IOReport private API symbols declared in bridging headers
  env.NIX_LDFLAGS = "-lIOReport";

  # Swift 5.10 doesn't support trailing commas in argument lists (Swift 6 feature)
  # Remove them from all Swift source files
  postPatch = ''
    find . -name '*.swift' -exec perl -0777 -pi -e '
      s/,(\s*\))/$1/g;
      s/\@retroactive //g;
    ' {} +

    # CWPHYMode.mode11be (WiFi 7) requires macOS 15+ SDK; @unknown default covers it
    sed -i '/mode11be/d' Modules/Net/readers.swift

  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    buildDir="$PWD/build"
    mkdir -p "$buildDir"

    commonSwiftFlags=(
      -O
      -Xcc -IKit/lldb
      -Xcc -IKit/lldb/include
      -Xcc -I${leveldb.dev}/include/leveldb
      -disable-bridging-pch
      # Stamp binaries with macOS 26 SDK version so the system applies Liquid Glass UI
      # The Swift compiler in nixpkgs uses SDK 14 headers (which compile fine), but without
      # this flag the linker records SDK 14 and macOS withholds it (Liquid Glass)
      -Xlinker -platform_version -Xlinker macos -Xlinker 14.0 -Xlinker 26.0
    )

    buildFramework() {
      local name="$1"
      shift
      local bridgingHeader="$1"
      shift
      local extraFlags=("$@")

      echo "Building framework: $name"

      local swiftFiles=()
      while IFS= read -r -d "" f; do
        swiftFiles+=("$f")
      done < <(find "$name" -name '*.swift' -print0 2>/dev/null)

      # For modules in Modules/ subdirectory
      if [ ''${#swiftFiles[@]} -eq 0 ]; then
        while IFS= read -r -d "" f; do
          swiftFiles+=("$f")
        done < <(find "Modules/$name" -name '*.swift' -print0 2>/dev/null)
      fi

      local bridgeFlags=()
      if [ -n "$bridgingHeader" ]; then
        bridgeFlags=(-import-objc-header "$bridgingHeader")
      fi

      swiftc \
        "''${commonSwiftFlags[@]}" \
        -emit-module \
        -emit-library \
        -module-name "$name" \
        -module-link-name "$name" \
        -emit-module-path "$buildDir/$name.swiftmodule" \
        "''${bridgeFlags[@]}" \
        -I "$buildDir" \
        -L "$buildDir" \
        -Xlinker -install_name -Xlinker "@rpath/$name.framework/$name" \
        "''${extraFlags[@]}" \
        "''${swiftFiles[@]}" \
        -o "$buildDir/lib$name.dylib"
    }

    echo "=== Building Kit ==="

    # Compile lldb.m (Objective-C++ with LevelDB)
    clang++ -x objective-c++ \
      -I Kit/lldb/include \
      -I Kit/lldb \
      -I ${leveldb.dev}/include/leveldb \
      -fobjc-arc \
      -O2 \
      -c Kit/lldb/lldb.m \
      -o "$buildDir/lldb.o"

    kitSwiftFiles=()
    while IFS= read -r -d "" f; do
      kitSwiftFiles+=("$f")
    done < <(find Kit -name '*.swift' -print0)
    # Kit also compiles shared SMC source files (protocol.swift, smc.swift)
    kitSwiftFiles+=("SMC/Helper/protocol.swift" "SMC/smc.swift")

    swiftc \
      "''${commonSwiftFlags[@]}" \
      -emit-module \
      -emit-library \
      -module-name Kit \
      -module-link-name Kit \
      -emit-module-path "$buildDir/Kit.swiftmodule" \
      -import-objc-header "Kit/Supporting Files/Kit.h" \
      -Xcc -IKit/lldb \
      -Xcc -IKit/lldb/include \
      -Xcc -I${leveldb.dev}/include/leveldb \
      -Xlinker -install_name -Xlinker "@rpath/Kit.framework/Kit" \
      "$buildDir/lldb.o" \
      -L ${leveldb}/lib -lleveldb \
      -lstdc++ \
      "''${kitSwiftFiles[@]}" \
      -o "$buildDir/libKit.dylib"

    buildFramework CPU "Modules/CPU/bridge.h" \
      -lKit -framework IOKit

    buildFramework GPU "" \
      -lKit -framework IOKit -framework Metal

    buildFramework RAM "" \
      -lKit -framework IOKit

    buildFramework Disk "Modules/Disk/header.h" \
      -lKit -framework IOKit -framework DiskArbitration

    buildFramework Net "" \
      -lKit -framework IOKit -framework CoreWLAN -framework SystemConfiguration

    buildFramework Battery "" \
      -lKit -framework IOKit

    buildFramework Bluetooth "" \
      -lKit -framework IOKit -framework IOBluetooth -framework CoreBluetooth

    # Build Sensors - needs ObjC file too
    echo "Building framework: Sensors"

    # Compile reader.m (ObjC)
    clang -x objective-c \
      -I "Modules/Sensors" \
      -fobjc-arc \
      -O2 \
      -c Modules/Sensors/reader.m \
      -o "$buildDir/sensors_reader.o"

    sensorsSwiftFiles=()
    while IFS= read -r -d "" f; do
      sensorsSwiftFiles+=("$f")
    done < <(find Modules/Sensors -name '*.swift' -print0)

    swiftc \
      "''${commonSwiftFlags[@]}" \
      -emit-module \
      -emit-library \
      -module-name Sensors \
      -module-link-name Sensors \
      -emit-module-path "$buildDir/Sensors.swiftmodule" \
      -import-objc-header "Modules/Sensors/bridge.h" \
      -I "$buildDir" \
      -L "$buildDir" \
      -lKit \
      -framework IOKit \
      -Xlinker -install_name -Xlinker "@rpath/Sensors.framework/Sensors" \
      "$buildDir/sensors_reader.o" \
      "''${sensorsSwiftFiles[@]}" \
      -o "$buildDir/libSensors.dylib"

    buildFramework Clock "" \
      -lKit

    echo "=== Building Stats app ==="

    statsSwiftFiles=()
    while IFS= read -r -d "" f; do
      statsSwiftFiles+=("$f")
    done < <(find Stats -name '*.swift' -print0)

    swiftc \
      "''${commonSwiftFlags[@]}" \
      -emit-executable \
      -module-name Stats \
      -I "$buildDir" \
      -L "$buildDir" \
      ${lib.concatMapStringsSep " " (fw: "-l${fw}") frameworks} \
      -Xlinker -rpath -Xlinker "@executable_path/../Frameworks" \
      "''${statsSwiftFiles[@]}" \
      -o "$buildDir/Stats"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    app="$out/Applications/Stats.app"
    mkdir -p "$app/Contents/"{MacOS,Frameworks,Resources}

    cp "$buildDir/Stats" "$app/Contents/MacOS/Stats"

    # Install frameworks with generated Info.plists
    ${lib.concatMapStrings (fw: ''
      fwDir="$app/Contents/Frameworks/${fw}.framework"
      mkdir -p "$fwDir/Resources"
      cp "$buildDir/lib${fw}.dylib" "$fwDir/${fw}"
      printf '%s' ${lib.escapeShellArg (frameworkPlist fw)} > "$fwDir/Resources/Info.plist"
    '') frameworks}

    printf '%s' ${lib.escapeShellArg (mainInfoPlist finalAttrs.version)} > "$app/Contents/Info.plist"
    # Splice CFBundleVersion from upstream's checked-in Info.plist so it stays
    # in sync automatically — nix-update-script bumps the tag & hash, and the
    # new source tree carries the correct build number
    bundleVersion=$(sed -n '/<key>CFBundleVersion<\/key>/{n;s/.*<string>\(.*\)<\/string>.*/\1/p;}' \
      "Stats/Supporting Files/Info.plist")
    sed -i "s|</dict>|<key>CFBundleVersion</key><string>$bundleVersion</string></dict>|" \
      "$app/Contents/Info.plist"

    # Compile asset catalogs
    actool \
      --compile "$app/Contents/Resources" \
      --platform macosx \
      --minimum-deployment-target 14.0 \
      --app-icon AppIcon \
      "Stats/Supporting Files/Assets.xcassets"

    actool \
      --compile "$app/Contents/Frameworks/Kit.framework/Resources" \
      --platform macosx \
      --minimum-deployment-target 14.0 \
      "Kit/Supporting Files/Assets.xcassets"

    # Copy localization files
    find "Stats/Supporting Files" -name '*.lproj' -type d -exec cp -r {} "$app/Contents/Resources/" \;

    # Copy module config plists into each framework's Resources
    for mod in ${lib.concatStringsSep " " modules}; do
      if [ -f "Modules/$mod/config.plist" ]; then
        cp "Modules/$mod/config.plist" "$app/Contents/Frameworks/$mod.framework/Resources/config.plist"
      fi
    done

    makeWrapper "$app/Contents/MacOS/Stats" "$out/bin/stats"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/exelban/stats/releases/tag/v${finalAttrs.version}";
    description = "macOS system monitor in your menu bar";
    homepage = "https://github.com/exelban/stats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      FlameFlag
      emilytrau
    ];
    platforms = lib.platforms.darwin;
  };
})
