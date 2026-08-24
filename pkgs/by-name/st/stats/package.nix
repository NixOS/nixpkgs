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

  moduleConfigs = [
    {
      name = "CPU";
      bridgingHeader = "Modules/CPU/bridge.h";
      frameworks = [ "IOKit" ];
      libraries = [ "IOReport" ];
    }
    {
      name = "GPU";
      bridgingHeader = "Modules/GPU/bridge.h";
      frameworks = [
        "IOKit"
        "Metal"
      ];
      libraries = [ "IOReport" ];
    }
    {
      name = "RAM";
      frameworks = [ "IOKit" ];
    }
    {
      name = "Disk";
      bridgingHeader = "Modules/Disk/header.h";
      frameworks = [
        "IOKit"
        "DiskArbitration"
      ];
    }
    {
      name = "Net";
      frameworks = [
        "IOKit"
        "CoreWLAN"
        "SystemConfiguration"
      ];
    }
    {
      name = "Battery";
      frameworks = [ "IOKit" ];
    }
    {
      name = "Bluetooth";
      frameworks = [
        "IOKit"
        "IOBluetooth"
        "CoreBluetooth"
      ];
    }
    {
      name = "Sensors";
      bridgingHeader = "Modules/Sensors/bridge.h";
      frameworks = [ "IOKit" ];
      libraries = [ "IOReport" ];
      objcSource = "Modules/Sensors/reader.m";
    }
    { name = "Clock"; }
    { name = "Remote"; }
  ];

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

  findSwiftFiles = varName: dirs: ''
    ${varName}=()
    while IFS= read -r -d "" f; do
      ${varName}+=("$f")
    done < <(find ${lib.escapeShellArgs dirs} -name '*.swift' -print0 2>/dev/null)
  '';

  buildModuleShell =
    mod:
    let
      linkFlags = [
        "-lKit"
      ]
      ++ map (library: "-l${library}") (mod.libraries or [ ])
      ++ lib.concatMap (framework: [
        "-framework"
        framework
      ]) (mod.frameworks or [ ]);
    in
    ''
      echo "Building framework: ${mod.name}"

      ${lib.optionalString (mod ? objcSource) ''
        clang -x objective-c \
          -I "Modules/${mod.name}" \
          -fobjc-arc \
          -O2 \
          -c "${mod.objcSource}" \
          -o "$buildDir/${lib.toLower mod.name}_objc.o"
      ''}

      ${findSwiftFiles "swiftFiles" [
        mod.name
        "Modules/${mod.name}"
      ]}

      swiftc \
        "''${commonSwiftFlags[@]}" \
        -emit-module \
        -emit-library \
        -module-name "${mod.name}" \
        -module-link-name "${mod.name}" \
        -emit-module-path "$buildDir/${mod.name}.swiftmodule" \
        ${lib.optionalString (mod ? bridgingHeader) ''-import-objc-header "${mod.bridgingHeader}"''} \
        -I "$buildDir" \
        -L "$buildDir" \
        -Xlinker -install_name -Xlinker "@rpath/${mod.name}.framework/${mod.name}" \
        ${lib.escapeShellArgs linkFlags} \
        ${lib.optionalString (mod ? objcSource) ''"$buildDir/${lib.toLower mod.name}_objc.o"''} \
        "''${swiftFiles[@]}" \
        -o "$buildDir/lib${mod.name}.dylib"
    '';

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

    ${lib.concatMapStrings buildModuleShell moduleConfigs}

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
