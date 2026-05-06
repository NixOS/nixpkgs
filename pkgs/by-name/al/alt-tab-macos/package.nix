{
  lib,
  swiftPackages,
  fetchFromGitHub,
  darwin,
  actool,
  makeWrapper,
  nix-update-script,
}:

let
  inherit (swiftPackages) stdenv swift;

  toPlist = lib.generators.toPlist { escape = true; };

  sources = {
    shortcutRecorder = fetchFromGitHub {
      owner = "lwouis";
      repo = "ShortcutRecorder";
      rev = "594b360e07a8a368ffec2567f77e465477b9994f";
      hash = "sha256-U8AzrmSJyVfvN2ASRt+WWsIs0CRkndp5ieFhqOW9Sbg=";
    };
    swiftyBeaver = fetchFromGitHub {
      owner = "SwiftyBeaver";
      repo = "SwiftyBeaver";
      tag = "1.9.0";
      hash = "sha256-dJy4nHp6qJQZzSMj2HUJrx1OebJE8gnREXL0vCauMa0=";
    };
    letsMove = fetchFromGitHub {
      owner = "lwouis";
      repo = "LetsMove";
      rev = "7abf4daed1a25218f2b52f2dfd190aee5a50071c";
      hash = "sha256-jaIY8t4xJGSxkosR393iih0nSYDy+ktSYRul7amU2gY=";
    };
  };

  # Framework descriptors drive both the build (compilation) and the install
  # (bundle layout, Info.plist, optional resources). Order below is the final
  # `-l<name>` link order.
  #
  # Build shapes (exactly one of):
  #   swiftSrcDir:     directory to recursively find *.swift in (pure Swift module)
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
        headerGlob = ''"${sources.shortcutRecorder}"/Library/*.h'';
        sourceGlob = ''"${sources.shortcutRecorder}"/Library/*.m'';
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
      localizations = "${sources.shortcutRecorder}/Resources";
      xcassets = "${sources.shortcutRecorder}/Resources/Images.xcassets";
    }
    {
      name = "SwiftyBeaver";
      swiftSrcDir = "${sources.swiftyBeaver}/Sources";
    }
    {
      name = "LetsMove";
      objc = {
        moduleMap = ./stubs/LetsMove.modulemap;
        headerGlob = ''"${sources.letsMove}/LetsMove.h" "${sources.letsMove}/PFMoveApplication.h"'';
        sourceGlob = ''"${sources.letsMove}/PFMoveApplication.m"'';
        arc = false;
        includes = [ (toString sources.letsMove) ];
        sysFrameworks = [
          "Security"
          "AppKit"
          "Foundation"
        ];
      };
      localizations = toString sources.letsMove;
    }
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
    "-disable-bridging-pch"
    "-Xlinker"
    "-platform_version"
    "-Xlinker"
    "macos"
    "-Xlinker"
    "14.0"
    "-Xlinker"
    "26.0"
  ];

  # Upstream alt-tab-macos resource layout. Recursive find+cp to flatten into
  # Contents/Resources/. Extend if upstream introduces new asset directories
  # or file extensions.
  appResourceCopies = [
    {
      root = "resources/icons";
      pattern = "*.png";
    }
    {
      root = "resources/illustrations";
      pattern = "*.jpg";
    }
    {
      root = "resources/l10n";
      pattern = "*.lproj";
      type = "d";
      cpFlags = "-r";
    }
  ];

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

  mainInfoPlist =
    version:
    toPlist {
      ATSApplicationFontsPath = "";
      AppCenterApplicationForwarderEnabled = "0";
      AppCenterSecret = "";
      CFBundleDevelopmentRegion = "en";
      CFBundleExecutable = "AltTab";
      CFBundleIconFile = "app.icns";
      CFBundleIdentifier = "com.lwouis.alt-tab-macos";
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundleName = "AltTab";
      CFBundlePackageType = "APPL";
      CFBundleShortVersionString = version;
      CFBundleVersion = version;
      FeedbackToken = "";
      LSApplicationCategoryType = "public.app-category.utilities";
      LSMinimumSystemVersion = "10.12";
      LSUIElement = true;
      NSHumanReadableCopyright = "GPL-3.0 licence";
      NSPrincipalClass = "AppCenterApplication";
      NSSupportsAutomaticTermination = false;
      NSSupportsSuddenTermination = false;
      SUEnableAutomaticChecks = true;
      SUEnableJavaScript = true;
      SUFeedURL = "https://raw.githubusercontent.com/lwouis/alt-tab-macos/master/appcast.xml";
      SUPublicEDKey = "2e9SQOBoaKElchSa/4QDli/nvYkyuDNfynfzBF6vJK4=";
      SUScheduledCheckInterval = 604800;
    };

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

  # Build a pure-Swift module from a directory of .swift files.
  # Runs in a subshell so `files` stays scoped to this framework.
  buildSwiftModule = fw: ''
    (
      nixLog "Building ${fw.name}"
      mapfile -d ''' files < <(find ${fw.swiftSrcDir} -name '*.swift' -print0)
      ${swiftFrameworkLink {
        inherit (fw) name;
        sourcesExpr = ''"''${files[@]}"'';
      }}
    )
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
          ln -s "$h" "$hdrDir/$(basename "$h")"
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

        clang -dynamiclib ${lib.optionalString arc "-fobjc-arc"} "''${objs[@]}" \
          ${sysFrameworkFlags} \
          -install_name "@rpath/${fw.name}.framework/${fw.name}" \
          -o "$buildDir/lib${fw.name}.dylib"
      )
    '';

  # Dispatch to the right builder based on descriptor shape.
  buildFramework =
    fw:
    if fw ? swiftSrcDir then
      buildSwiftModule fw
    else if fw ? stubSrc then
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
        --platform macosx --minimum-deployment-target 14.0 \
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
      find "${fw.localizations}" -name '*.lproj' -type d -exec cp -r {} \
        "$fwDir/Resources/" \; 2>/dev/null || true
    ''}
    ${lib.optionalString (fw ? xcassets) (compileAssetCatalog {
      destDir = "$fwDir/Resources";
      catalog = fw.xcassets;
    })}
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "alt-tab-macos";
  version = "10.12.0";

  src = fetchFromGitHub {
    owner = "lwouis";
    repo = "alt-tab-macos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VAOVdLfwwwCetjKyYMON3gP16YpnvJKKXnl/nQ5pMb8=";
  };

  nativeBuildInputs = [
    swift
    actool
    darwin.autoSignDarwinBinariesHook
    makeWrapper
  ];

  # Swift 5.10 compatibility: count(where:), .extraLarge, Liquid Glass
  patches = [
    ./0001-replace-count-where-with-filter-.count-for-Swift-5.1.patch
    ./0002-replace-.extraLarge-with-.large-for-macOS-26-SDK.patch
    ./0003-replace-Liquid-Glass-NSGlassEffectView-inheritance-w.patch
  ];

  # Remove trailing comma incompatible with Swift 5.10
  postPatch = ''
    substituteInPlace src/ui/permission-window/PermissionsWindow.swift \
      --replace-fail \
        '"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility",' \
        '"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"'

    # Swift 5.10 compat: new call site in 10.12.0 using trailing-closure
    # sugar for count(where:). See 0001-replace-count-where-...patch.
    substituteInPlace src/logic/UsageStats.swift \
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

    nixLog "Building AltTab"
    mapfile -d ''' files < <(find src -name '*.swift' -not -path '*/experimentations/*' -print0)

    swiftc "''${commonSwiftFlags[@]}" \
      -emit-executable -module-name AltTab \
      -import-objc-header alt-tab-macos-Bridging-Header.h \
      -Xcc -Isrc/ui \
      -I "$buildDir" -L "$buildDir" \
      ${objcModuleMapFlags} \
      ${lib.concatMapStringsSep " " (fw: "-l${fw}") allFrameworks} \
      -F /System/Library/PrivateFrameworks \
      -framework SkyLight -framework Carbon -framework AppKit -framework Cocoa \
      -framework ScreenCaptureKit -framework ApplicationServices \
      -framework CoreGraphics -framework CoreText \
      -Xlinker -rpath -Xlinker "@executable_path/../Frameworks" \
      "$buildDir/AppCenterApplication.o" \
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

    printf '%s' ${lib.escapeShellArg (mainInfoPlist finalAttrs.version)} > "$app/Contents/Info.plist"

    # App resources go flat into Resources/ (not subdirectories) because the
    # Xcode project lists them as a PBXGroup, and NSImage(named:) won't find
    # files in subdirectories. If upstream adds new asset types (webp, svg,
    # ttf fonts, etc.) add the pattern here.
    cp resources/icons/app/app.icns "$app/Contents/Resources/app.icns"
    cp resources/*.otf "$app/Contents/Resources/"
    # AcknowledgmentsTab loads these via Bundle.main.url(forResource:withExtension:"md")!
    cp docs/contributors.md docs/acknowledgments.md "$app/Contents/Resources/"
    ${lib.concatMapStringsSep "\n" (spec: ''
      find ${spec.root} -name '${spec.pattern}' ${lib.optionalString (spec ? type) "-type ${spec.type}"} \
        -exec cp ${spec.cpFlags or ""} {} "$app/Contents/Resources/" \;
    '') appResourceCopies}

    makeWrapper "$app/Contents/MacOS/AltTab" "$out/bin/alt-tab"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Windows alt-tab on macOS";
    homepage = "https://alt-tab-macos.netlify.app";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      FlameFlag
      emilytrau
    ];
    mainProgram = "alt-tab";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
