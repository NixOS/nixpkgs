{
  lib,
  swiftPackages,
  fetchFromGitHub,
  leveldb,
  perl,
  actool,
  makeBinaryWrapper,
  re-plistbuddy,
  rcodesign,
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
    "Remote"
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

in
stdenv.mkDerivation (finalAttrs: {
  pname = "stats";
  version = "3.0.13";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "exelban";
    repo = "Stats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0EDQnMD/Cm2DG0bgt6MVexbVBWObRkF1OXnLwdy3TAo=";
  };

  nativeBuildInputs = [
    swift
    perl
    actool
    makeBinaryWrapper
    rcodesign
  ];

  buildInputs = [ leveldb ];

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
      -lKit -lIOReport -framework IOKit

    buildFramework GPU "Modules/GPU/bridge.h" \
      -lKit -lIOReport -framework IOKit -framework Metal

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
      -lKit -lIOReport \
      -framework IOKit \
      -Xlinker -install_name -Xlinker "@rpath/Sensors.framework/Sensors" \
      "$buildDir/sensors_reader.o" \
      "''${sensorsSwiftFiles[@]}" \
      -o "$buildDir/libSensors.dylib"

    buildFramework Clock "" \
      -lKit

    buildFramework Remote "" \
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
    appInfo="$app/Contents/Info.plist"
    assetInfo="$NIX_BUILD_TOP/asset-info.plist"
    mkdir -p "$app/Contents/"{MacOS,Frameworks,Resources}

    cp "$buildDir/Stats" "$app/Contents/MacOS/Stats"

    # Install frameworks with generated Info.plists
    ${lib.concatMapStrings (fw: ''
      fwDir="$app/Contents/Frameworks/${fw}.framework"
      mkdir -p "$fwDir/Resources"
      cp "$buildDir/lib${fw}.dylib" "$fwDir/${fw}"
      printf '%s' ${lib.escapeShellArg (frameworkPlist fw)} > "$fwDir/Resources/Info.plist"
    '') frameworks}

    # Keep upstream's plist as the source of truth so privacy and bundle
    # metadata added by upstream are retained.
    cp "Stats/Supporting Files/Info.plist" "$appInfo"
    substituteInPlace "$appInfo" \
      --replace-fail '$(DEVELOPMENT_LANGUAGE)' "en" \
      --replace-fail '$(EXECUTABLE_NAME)' "Stats" \
      --replace-fail '$(PRODUCT_BUNDLE_IDENTIFIER)' "eu.exelban.Stats" \
      --replace-fail '$(PRODUCT_NAME)' "Stats" \
      --replace-fail '$(MARKETING_VERSION)' "${finalAttrs.version}" \
      --replace-fail '$(MACOSX_DEPLOYMENT_TARGET)' "12.0"

    # Compile asset catalogs
    actool \
      --compile "$app/Contents/Resources" \
      --platform macosx \
      --minimum-deployment-target 14.0 \
      --app-icon AppIcon \
      --output-partial-info-plist "$assetInfo" \
      "Stats/Supporting Files/Assets.xcassets"

    ${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Merge $assetInfo" "$appInfo"
    ${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Delete :SMPrivilegedExecutables" "$appInfo"

    # Copy localization files
    find "Stats/Supporting Files" -name '*.lproj' -type d -exec cp -r {} "$app/Contents/Resources/" \;

    # Copy module config plists into each framework's Resources
    for mod in ${lib.concatStringsSep " " modules}; do
      cp "Modules/$mod/config.plist" "$app/Contents/Frameworks/$mod.framework/Resources/config.plist"
    done

    makeWrapper "$app/Contents/MacOS/Stats" "$out/bin/stats"

    runHook postInstall
  '';

  # Stats is an app bundle with nested frameworks, so sign the bundle to generate
  # sealed resources instead of signing only the Mach-O files.
  postFixup = ''
    ${lib.getExe rcodesign} sign "$out/Applications/Stats.app"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/exelban/stats/releases/tag/v${finalAttrs.version}";
    description = "macOS system monitor in your menu bar";
    homepage = "https://github.com/exelban/stats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      _4evy
      emilytrau
      kinnrai
    ];
    platforms = lib.platforms.darwin;
  };
})
