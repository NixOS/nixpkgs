{
  lib,
  swiftPackages,
  fetchFromGitHub,
  actool,
  lld,
  makeWrapper,
  nix-update-script,
  rcodesign,
}:

let
  inherit (swiftPackages) stdenv swift;

  toPlist = lib.generators.toPlist { escape = true; };
  deploymentTarget = "14.0";
  sdkVersion = "26.0";
  shortcutRecorderDir = "vendor/ShortcutRecorder/Sources/ShortcutRecorder";

  # Framework descriptors drive both the build (compilation) and the install
  # (bundle layout, Info.plist, optional resources). Order below is the final
  # `-l<name>` link order.
  #
  # Build shapes (exactly one of):
  #   stubSrc:         single-file Swift stub (+ optional stubExtraFlags)
  #   objc = { ... }:  Objective-C framework; see buildObjcFramework for keys
  #
  # Install extras (all optional):
  #   plistOverrides:  extra CFBundle* keys merged into the framework Info.plist
  #   localizations:   directory to scan for *.lproj dirs to copy into Resources
  #   xcassets:        .xcassets directory compiled with actool into Assets.car
  frameworks = [
    {
      name = "ShortcutRecorder";
      objc = {
        moduleMap = ./stubs/ShortcutRecorder.modulemap;
        headerGlob = ''"${shortcutRecorderDir}"/include/ShortcutRecorder/*.h'';
        sourceGlob = ''"${shortcutRecorderDir}"/*.m'';
        includes = [
          "${shortcutRecorderDir}/include"
          "${shortcutRecorderDir}/include/ShortcutRecorder"
        ];
        sysFrameworks = [
          "Carbon"
          "AppKit"
          "Foundation"
          "CoreData"
        ];
      };
      # ShortcutRecorder looks up its own bundle via SRBundle() by identifier
      plistOverrides = {
        CFBundleIdentifier = "com.kulakov.ShortcutRecorder";
        CFBundleVersion = "3.1";
        CFBundleShortVersionString = "3.1";
      };
      localizations = shortcutRecorderDir;
      xcassets = "${shortcutRecorderDir}/Images.xcassets";
    }
    # Updates are managed by Nix, and upstream's AppCenter package depends on
    # a prebuilt PLCrashReporter xcframework. API-compatible stubs keep both
    # network-facing services disabled while preserving a source-only build.
    {
      name = "Sparkle";
      stubSrc = ./stubs/SparkleStub.swift;
    }
    {
      name = "AppCenter";
      stubSrc = ./stubs/AppCenterStub.swift;
    }
    {
      name = "AppCenterCrashes";
      stubSrc = ./stubs/AppCenterCrashesStub.swift;
      stubExtraFlags = [
        "-I"
        "$buildDir"
        "-L"
        "$buildDir"
        "-lAppCenter"
      ];
    }
  ];

  allFrameworks = lib.catAttrs "name" frameworks;
  objcFrameworks = lib.filter (fw: fw ? objc) frameworks;

  # apple-sdk_26 cannot be used here because swiftPackages compiles its own modules
  # against apple-sdk_14; adding it to buildInputs redirects SDKROOT and breaks Swift's
  # foundational modules
  commonSwiftFlags = [
    "-O"
    "-swift-version"
    "5"
    "-disable-bridging-pch"
    "-Xlinker"
    "-platform_version"
    "-Xlinker"
    "macos"
    "-Xlinker"
    deploymentTarget
    "-Xlinker"
    sdkVersion
  ];

  # These are the non-localized files in upstream's PBXResourcesBuildPhase.
  appResources = [
    "resources/icons/app/app.icns"
    "resources/icons/menubar/*.pdf"
    "resources/illustrations/*.heic"
    "resources/*.otf"
    "docs/contributors.md"
    "docs/acknowledgments.md"
  ];

  infoPlistSubstitutions = version: {
    API_DOMAIN = "alt-tab.app/api";
    APPCENTER_SECRET = "";
    CURRENT_PROJECT_VERSION = version;
    DOMAIN = "alt-tab.app";
    EXECUTABLE_NAME = "AltTab";
    MACOSX_DEPLOYMENT_TARGET = deploymentTarget;
    PRODUCT_BUNDLE_IDENTIFIER = "com.lwouis.alt-tab-macos";
    PRODUCT_NAME = "AltTab";
  };

  substitutePlistVariables =
    substitutions:
    lib.concatStringsSep " \\\n        " (
      lib.mapAttrsToList (
        name: value: "--replace-fail ${lib.escapeShellArg "$(${name})"} ${lib.escapeShellArg value}"
      ) substitutions
    );

  frameworkPlist =
    name: extra:
    toPlist (
      {
        CFBundleExecutable = name;
        CFBundleIdentifier = "com.lwouis.alt-tab-macos.${name}";
        CFBundleInfoDictionaryVersion = "6.0";
        CFBundleName = name;
        CFBundlePackageType = "FMWK";
        CFBundleVersion = "1";
      }
      // extra
    );

  # Shared swiftc invocation for emitting a dylib + swiftmodule for <name>.
  # `sourcesExpr` is inlined into the swiftc command line: either a single
  # path (stub), or a bash array expansion like "${foo[@]}" (glob output).
  swiftFrameworkLink =
    {
      name,
      sourcesExpr,
      extraFlags ? [ ],
    }:
    ''
      swiftc "''${commonSwiftFlags[@]}" \
        -emit-module -emit-library \
        -module-name ${name} -module-link-name ${name} \
        -emit-module-path "$buildDir/${name}.swiftmodule" \
        ${lib.concatStringsSep " " extraFlags} \
        -Xlinker -install_name -Xlinker "@rpath/${name}.framework/${name}" \
        ${sourcesExpr} -o "$buildDir/lib${name}.dylib"
    '';

  # Build a single-file Swift stub framework.
  buildSwiftStubFramework = fw: ''
    nixLog "Building ${fw.name} (stub)"
    ${swiftFrameworkLink {
      inherit (fw) name;
      sourcesExpr = "${fw.stubSrc}";
      extraFlags = fw.stubExtraFlags or [ ];
    }}
  '';

  # Build an Objective-C dynamic framework: symlink headers + modulemap under
  # $buildDir/<name>_headers/<name>/, compile each .m to .o, then link a dylib.
  #   moduleMap:     path to a .modulemap file (copied in place)
  #   headerGlob:    bash expression expanding to header paths (for ln -s)
  #   sourceGlob:    bash expression expanding to .m paths (one .o per source)
  #   arc:           enable -fobjc-arc (default true)
  #   includes:      extra -I paths passed to clang
  #   sysFrameworks: macOS system frameworks to link
  buildObjcFramework =
    fw:
    let
      o = fw.objc;
      arc = o.arc or true;
      arcFlag = if arc then "-fobjc-arc" else "-fno-objc-arc";
      includeFlags = lib.concatMapStringsSep " " (p: ''-I "${p}"'') (o.includes or [ ]);
      sysFrameworkFlags = lib.concatMapStringsSep " " (f: "-framework ${f}") (o.sysFrameworks or [ ]);
    in
    ''
      (
        nixLog "Building ${fw.name}"
        hdrDir="$buildDir/${fw.name}_headers/${fw.name}"
        mkdir -p "$hdrDir"
        for h in ${o.headerGlob}; do
          ln -s "$(realpath "$h")" "$hdrDir/$(basename "$h")"
        done
        cp ${o.moduleMap} "$hdrDir/module.modulemap"

        objs=()
        for f in ${o.sourceGlob}; do
          obj="$buildDir/${fw.name}_$(basename "$f" .m).o"
          clang ${arcFlag} -O2 -Wno-deprecated-declarations \
            -I "$buildDir/${fw.name}_headers" ${includeFlags} \
            -c "$f" -o "$obj"
          objs+=("$obj")
        done

        clang -fuse-ld=lld -dynamiclib ${lib.optionalString arc "-fobjc-arc"} "''${objs[@]}" \
          ${sysFrameworkFlags} \
          -install_name "@rpath/${fw.name}.framework/${fw.name}" \
          -o "$buildDir/lib${fw.name}.dylib"
      )
    '';

  # Dispatch to the right builder based on descriptor shape.
  buildFramework =
    fw:
    if fw ? stubSrc then
      buildSwiftStubFramework fw
    else if fw ? objc then
      buildObjcFramework fw
    else
      throw "framework ${fw.name} has no build descriptor";

  # Module-map flags for the final AltTab swiftc invocation, so Swift code can
  # `import <ObjcFrameworkName>`. Flat single line so the surrounding `\`
  # continuation in the swiftc call stays intact.
  objcModuleMapFlags = lib.concatMapStringsSep " " (
    fw:
    ''-Xcc -fmodule-map-file="$buildDir/${fw.name}_headers/${fw.name}/module.modulemap" -Xcc -I"$buildDir/${fw.name}_headers"''
  ) objcFrameworks;

  # Compile an xcassets catalog into Assets.car in destDir
  compileAssetCatalog =
    { destDir, catalog }:
    ''
      actool --compile "${destDir}" \
        --platform macosx --minimum-deployment-target ${deploymentTarget} \
        --output-partial-info-plist /dev/null \
        "${catalog}"
    '';

  # Assemble one framework bundle: dylib + Info.plist + optional resources.
  # Runs in the install phase where $app and $buildDir are set.
  installFramework = fw: ''
    fwDir="$app/Contents/Frameworks/${fw.name}.framework"
    mkdir -p "$fwDir/Resources"
    cp "$buildDir/lib${fw.name}.dylib" "$fwDir/${fw.name}"
    printf '%s' ${
      lib.escapeShellArg (frameworkPlist fw.name (fw.plistOverrides or { }))
    } > "$fwDir/Resources/Info.plist"
    ${lib.optionalString (fw ? localizations) ''
      cp -R "${fw.localizations}"/*.lproj "$fwDir/Resources/"
    ''}
    ${lib.optionalString (fw ? xcassets) (compileAssetCatalog {
      destDir = "$fwDir/Resources";
      catalog = fw.xcassets;
    })}
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "alt-tab-macos";
  version = "11.4.3";

  src = fetchFromGitHub {
    owner = "lwouis";
    repo = "alt-tab-macos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-izPiRGV8bD67rvOyNWShcpTbUujn6WHnzenPAMAlKoU=";
  };

  nativeBuildInputs = [
    swift
    actool
    lld
    makeWrapper
    rcodesign
  ];

  patches = [
    # Swift 5.10 compatibility: count(where:), .extraLarge, Liquid Glass
    ./0001-replace-count-where-with-filter-.count-for-Swift-5.1.patch
    ./0002-replace-.extraLarge-with-.large-for-macOS-14-SDK.patch
    ./0003-use-runtime-dispatch-for-Liquid-Glass-with-SDK-14.patch
    # Don't offer preferences for services disabled by the source-only stubs.
    ./0004-hide-settings-for-disabled-services.patch
  ];

  # Remove trailing comma incompatible with Swift 5.10
  postPatch = ''
    substituteInPlace Info.plist \
      ${substitutePlistVariables (infoPlistSubstitutions finalAttrs.version)}

    substituteInPlace src/secondary-windows/permission-window/PermissionsWindow.swift \
      --replace-fail \
        '"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility",' \
        '"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"'

    # Swift 5.10 compat: additional call site using trailing-closure
    # sugar for count(where:). See 0001-replace-count-where-...patch.
    substituteInPlace src/util/UsageStats.swift \
      --replace-fail \
        'getTimestamps(key).count { $0 >= threshold }' \
        'getTimestamps(key).filter { $0 >= threshold }.count'
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    buildDir="$PWD/build"
    mkdir -p "$buildDir"

    ${lib.toShellVars { inherit commonSwiftFlags; }}

    ${lib.concatMapStringsSep "\n" buildFramework frameworks}

    nixLog "Compiling AppCenterApplication"
    clang -fobjc-arc -fmodules -fmodules-cache-path="$buildDir/module-cache" -O2 \
      -c ${./stubs/AppCenterApplication.m} -o "$buildDir/AppCenterApplication.o"

    nixLog "Compiling ObjCExceptionCatcher"
    clang -fobjc-arc -fmodules -fmodules-cache-path="$buildDir/module-cache" -O2 \
      -c src/vendors/ObjCExceptionCatcher.m -o "$buildDir/ObjCExceptionCatcher.o"

    nixLog "Building AltTab"
    mapfile -d ''' files < <(find src -name '*.swift' \
      -not -name '*Tests.swift' \
      -not -path '*/_test-support/*' \
      -not -path '*/experimentations/*' \
      -print0)

    swiftc "''${commonSwiftFlags[@]}" \
      -emit-executable -module-name AltTab \
      -import-objc-header alt-tab-macos-Bridging-Header.h \
      -Xcc -Isrc/ui \
      -Xcc -Isrc/vendors \
      -I "$buildDir" -L "$buildDir" \
      ${objcModuleMapFlags} \
      ${lib.concatMapStringsSep " " (fw: "-l${fw}") allFrameworks} \
      -F /System/Library/PrivateFrameworks \
      -framework SkyLight -framework Carbon -framework AppKit -framework Cocoa \
      -framework ScreenCaptureKit -framework ApplicationServices \
      -framework CoreGraphics -framework CoreText \
      -Xlinker -rpath -Xlinker "@executable_path/../Frameworks" \
      "$buildDir/AppCenterApplication.o" \
      "$buildDir/ObjCExceptionCatcher.o" \
      "''${files[@]}" -o "$buildDir/AltTab"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    app="$out/Applications/AltTab.app"
    mkdir -p "$app/Contents/"{MacOS,Frameworks,Resources}

    cp "$buildDir/AltTab" "$app/Contents/MacOS/AltTab"

    # Install each framework: dylib + Info.plist + optional resources
    ${lib.concatMapStringsSep "\n" installFramework frameworks}

    cp Info.plist "$app/Contents/Info.plist"
    printf 'APPL????' > "$app/Contents/PkgInfo"

    # Xcode flattens these PBXGroup resources into Contents/Resources.
    cp ${lib.concatStringsSep " " appResources} "$app/Contents/Resources/"
    cp -R resources/l10n/*.lproj "$app/Contents/Resources/"

    makeWrapper "$app/Contents/MacOS/AltTab" "$out/bin/alt-tab"

    runHook postInstall
  '';

  # Sign the complete app rather than each Mach-O independently, so its nested
  # frameworks and resources are sealed as one valid bundle. Match upstream's
  # hardened-runtime flags and entitlements on the main executable. This must
  # remain ad-hoc: a stable designated requirement needs a private signing
  # identity, which cannot be embedded in a public, sandboxed Nix build.
  postFixup = ''
    ${lib.getExe rcodesign} sign \
      --code-signature-flags runtime \
      --entitlements-xml-file ${finalAttrs.src}/alt_tab_macos.entitlements \
      "$out/Applications/AltTab.app"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Windows alt-tab on macOS";
    homepage = "https://alt-tab.app";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-40 # ShortcutRecorder
    ];
    mainProgram = "alt-tab";
    maintainers = with lib.maintainers; [
      _4evy
      emilytrau
      Br1ght0ne
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
