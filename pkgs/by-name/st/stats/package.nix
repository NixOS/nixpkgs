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

  moduleConfigs = [
    {
      name = "CPU";
      bridgingHeader = "Modules/CPU/bridge.h";
      sysFrameworks = [ "IOKit" ];
    }
    {
      name = "GPU";
      bridgingHeader = "Modules/GPU/bridge.h";
      sysFrameworks = [
        "IOKit"
        "Metal"
      ];
    }
    {
      name = "RAM";
      sysFrameworks = [ "IOKit" ];
    }
    {
      name = "Disk";
      bridgingHeader = "Modules/Disk/header.h";
      sysFrameworks = [
        "IOKit"
        "DiskArbitration"
      ];
    }
    {
      name = "Net";
      sysFrameworks = [
        "IOKit"
        "CoreWLAN"
        "SystemConfiguration"
      ];
    }
    {
      name = "Battery";
      sysFrameworks = [ "IOKit" ];
    }
    {
      name = "Bluetooth";
      sysFrameworks = [
        "IOKit"
        "IOBluetooth"
        "CoreBluetooth"
      ];
    }
    { name = "Sensors"; } # custom build (ObjC + Swift)
    { name = "Clock"; }
  ];

  genericModules = lib.filter (m: m.name != "Sensors") moduleConfigs;
  allFrameworkNames = [ "Kit" ] ++ map (m: m.name) moduleConfigs;
  moduleNames = lib.tail allFrameworkNames;

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

  # Collect .swift files from directories into a bash array variable
  findSwiftFiles = varName: dirs: ''
    ${varName}=()
    while IFS= read -r -d "" f; do
      ${varName}+=("$f")
    done < <(find ${lib.escapeShellArgs dirs} -name '*.swift' -print0 2>/dev/null)
  '';

  # Full swiftc invocation for a generic module
  buildModuleShell = mod: ''
    nixLog "Building framework: ${mod.name}"

    ${findSwiftFiles "swiftFiles" [
      mod.name
      "Modules/${mod.name}"
    ]}

    swiftc \
      "''${commonSwiftFlags[@]}" \
      -emit-module -emit-library \
      -module-name ${mod.name} -module-link-name ${mod.name} \
      -emit-module-path "$buildDir/${mod.name}.swiftmodule" \
      ${lib.optionalString (mod ? bridgingHeader) ''-import-objc-header "${mod.bridgingHeader}"''} \
      -I "$buildDir" -L "$buildDir" \
      -Xlinker -install_name -Xlinker "@rpath/${mod.name}.framework/${mod.name}" \
      -lKit ${lib.concatMapStringsSep " " (f: "-framework ${f}") (mod.sysFrameworks or [ ])} \
      "''${swiftFiles[@]}" \
      -o "$buildDir/lib${mod.name}.dylib"
  '';

  # Sensors needs ObjC compilation before Swift
  buildSensorsShell = ''
    nixLog "Building framework: Sensors"

    clang -x objective-c \
      -I "Modules/Sensors" \
      -fobjc-arc -O2 \
      -c Modules/Sensors/reader.m \
      -o "$buildDir/sensors_reader.o"

    ${findSwiftFiles "sensorsSwiftFiles" [ "Modules/Sensors" ]}

    swiftc \
      "''${commonSwiftFlags[@]}" \
      -emit-module -emit-library \
      -module-name Sensors -module-link-name Sensors \
      -emit-module-path "$buildDir/Sensors.swiftmodule" \
      -import-objc-header "Modules/Sensors/bridge.h" \
      -I "$buildDir" -L "$buildDir" \
      -lKit -framework IOKit \
      -Xlinker -install_name -Xlinker "@rpath/Sensors.framework/Sensors" \
      "$buildDir/sensors_reader.o" \
      "''${sensorsSwiftFiles[@]}" \
      -o "$buildDir/libSensors.dylib"
  '';

  # Compile an asset catalog
  compileAssetCatalog =
    {
      destDir,
      catalog,
      appIcon ? null,
    }:
    ''
      actool \
        --compile "${destDir}" \
        --platform macosx \
        --minimum-deployment-target 14.0 \
        ${lib.optionalString (appIcon != null) "--app-icon ${appIcon}"} \
        "${catalog}"
    '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stats";
  version = "2.12.9";

  src = fetchFromGitHub {
    owner = "exelban";
    repo = "Stats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yp8B2VdOkt8hWp0jR2CActZw2Q/NWLPeTRmEGdvAyhc=";
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

    nixLog "Building Kit"

    # Compile lldb.m (Objective-C++ with LevelDB)
    clang++ -x objective-c++ \
      -I Kit/lldb/include \
      -I Kit/lldb \
      -I ${leveldb.dev}/include/leveldb \
      -fobjc-arc \
      -O2 \
      -c Kit/lldb/lldb.m \
      -o "$buildDir/lldb.o"

    ${findSwiftFiles "kitSwiftFiles" [ "Kit" ]}
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

    ${lib.concatMapStrings buildModuleShell genericModules}

    ${buildSensorsShell}

    nixLog "Building Stats app"

    ${findSwiftFiles "statsSwiftFiles" [ "Stats" ]}

    swiftc \
      "''${commonSwiftFlags[@]}" \
      -emit-executable \
      -module-name Stats \
      -I "$buildDir" \
      -L "$buildDir" \
      ${lib.concatMapStringsSep " " (name: "-l${name}") allFrameworkNames} \
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
    ${lib.concatMapStrings (name: ''
      fwDir="$app/Contents/Frameworks/${name}.framework"
      mkdir -p "$fwDir/Resources"
      cp "$buildDir/lib${name}.dylib" "$fwDir/${name}"
      printf '%s' ${lib.escapeShellArg (frameworkPlist name)} > "$fwDir/Resources/Info.plist"
    '') allFrameworkNames}

    printf '%s' ${lib.escapeShellArg (mainInfoPlist finalAttrs.version)} > "$app/Contents/Info.plist"
    # Splice CFBundleVersion from upstream's checked-in Info.plist so it stays
    # in sync automatically — nix-update-script bumps the tag & hash, and the
    # new source tree carries the correct build number
    bundleVersion=$(sed -n '/<key>CFBundleVersion<\/key>/{n;s/.*<string>\(.*\)<\/string>.*/\1/p;}' \
      "Stats/Supporting Files/Info.plist")
    sed -i "s|</dict>|<key>CFBundleVersion</key><string>$bundleVersion</string></dict>|" \
      "$app/Contents/Info.plist"

    ${compileAssetCatalog {
      destDir = "$app/Contents/Resources";
      catalog = "Stats/Supporting Files/Assets.xcassets";
      appIcon = "AppIcon";
    }}

    ${compileAssetCatalog {
      destDir = "$app/Contents/Frameworks/Kit.framework/Resources";
      catalog = "Kit/Supporting Files/Assets.xcassets";
    }}

    # Copy localization files
    find "Stats/Supporting Files" -name '*.lproj' -type d -exec cp -r {} "$app/Contents/Resources/" \;

    # Copy module config plists into each framework's Resources
    ${lib.concatMapStrings (name: ''
      if [ -f "Modules/${name}/config.plist" ]; then
        cp "Modules/${name}/config.plist" "$app/Contents/Frameworks/${name}.framework/Resources/config.plist"
      fi
    '') moduleNames}

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
