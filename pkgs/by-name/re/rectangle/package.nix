{
  lib,
  swiftPackages,
  fetchFromGitHub,
  darwin,
  actool,
  ibtool,
  makeWrapper,
  nix-update-script,
}:

let
  inherit (swiftPackages) stdenv swift;

  masShortcutSrc = fetchFromGitHub {
    owner = "rxhanson";
    repo = "MASShortcut";
    rev = "2f9fbb3f959b7a683c6faaf9638d22afad37a235";
    hash = "sha256-EZLt7ph24L1wwFEMlltuPutId09RBug/y9OtDhixIig=";
  };

  masShortcutSources = [
    "Model/MASShortcut.m"
    "Model/MASShortcutValidator.m"
    "Monitoring/MASHotKey.m"
    "Monitoring/MASShortcutMonitor.m"
    "UI/MASLocalization.m"
    "UI/MASShortcutView.m"
    "UI/MASShortcutView+Bindings.m"
    "UI/MASShortcutViewButtonCell.m"
    "User Defaults Storage/MASDictionaryTransformer.m"
    "User Defaults Storage/MASShortcutBinder.m"
  ];

  # Derive object file name from source path: "UI/MASShortcutView.m" -> "MASShortcutView"
  objName = src: lib.removeSuffix ".m" (baseNameOf src);

  toPlist = lib.generators.toPlist { escape = true; };

  # Standard macOS app plist fields. Pass app-specific attrs to override/extend.
  mkAppPlist =
    attrs:
    toPlist (
      {
        CFBundleInfoDictionaryVersion = "6.0";
        CFBundlePackageType = "APPL";
        LSMinimumSystemVersion = "10.15";
        NSMainStoryboardFile = "Main";
        NSPrincipalClass = "NSApplication";
      }
      // attrs
    );

  mkFrameworkPlist =
    name:
    toPlist {
      CFBundleExecutable = name;
      CFBundleIdentifier = "com.knollsoft.Rectangle.${name}";
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundleName = name;
      CFBundlePackageType = "FMWK";
      CFBundleVersion = "1";
    };

  # Generate shell to assemble a .app bundle: directory structure, binary,
  # frameworks (with plists and optional localizations), auto-discovered IB
  # resources, localizations, and Info.plist
  # Requires compileIB and installLocalizations shell functions in scope
  mkAppBundle =
    {
      name,
      binary,
      sourceDir,
      plist,
      destDir,
      frameworks ? [ ],
    }:
    let
      app = "${destDir}/${name}.app";
    in
    ''
      nixLog "assembling ${name}.app"
      mkdir -p "${app}/Contents/"{MacOS,Resources}
      cp "${binary}" "${app}/Contents/MacOS/${name}"

      ${lib.concatMapStrings (fw: ''
        nixLog "installing framework: ${fw.name}"
        mkdir -p "${app}/Contents/Frameworks/${fw.name}.framework/Resources"
        cp "${fw.dylib}" "${app}/Contents/Frameworks/${fw.name}.framework/${fw.name}"
        printf '%s' ${lib.escapeShellArg (mkFrameworkPlist fw.name)} \
          > "${app}/Contents/Frameworks/${fw.name}.framework/Resources/Info.plist"
        ${lib.optionalString (fw ? localizations) ''
          find "${fw.localizations}" -name '*.lproj' -type d \
            -exec cp -r {} "${app}/Contents/Frameworks/${fw.name}.framework/Resources/" \;
        ''}
      '') frameworks}

      while IFS= read -r -d "" f; do
        compileIB "$f" "${app}/Contents/Resources"
      done < <(find ${sourceDir} \( -name '*.storyboard' -o -name '*.xib' \) -print0)

      installLocalizations ${sourceDir} "${app}/Contents/Resources"
      printf '%s' ${lib.escapeShellArg plist} > "${app}/Contents/Info.plist"
    '';

  mainInfoPlist =
    version:
    mkAppPlist {
      CFBundleDevelopmentRegion = "en";
      CFBundleExecutable = "Rectangle";
      CFBundleIdentifier = "com.knollsoft.Rectangle";
      CFBundleName = "Rectangle";
      CFBundleShortVersionString = version;
      CFBundleVersion = "100";
      CFBundleURLTypes = [ { CFBundleURLSchemes = [ "rectangle" ]; } ];
      CFBundleIconFile = "AppIcon";
      CFBundleIconName = "AppIcon";
      LSApplicationCategoryType = "public.app-category.productivity";
      LSUIElement = true;
      NSHumanReadableCopyright = "Copyright © 2019-2026 Ryan Hanson. All rights reserved.";
      SUFeedURL = "https://rectangleapp.com/downloads/updates.xml";
      SUPublicEDKey = "lpt9M3PhocbZ3MZiLH+crEqRfU11kfoNzGxSqiEIdvM=";
      SUScheduledCheckInterval = 172800;
    };

  launcherInfoPlist = mkAppPlist {
    CFBundleExecutable = "RectangleLauncher";
    CFBundleIdentifier = "com.knollsoft.RectangleLauncher";
    CFBundleName = "RectangleLauncher";
    CFBundleShortVersionString = "1.0";
    CFBundleVersion = "1";
    LSBackgroundOnly = true;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rectangle";
  version = "0.95";

  src = fetchFromGitHub {
    owner = "rxhanson";
    repo = "Rectangle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M/qZo2dWsFQxiBD5ypKh0M7AdHdLkY/rx4Lx01OBSlc=";
  };

  nativeBuildInputs = [
    swift
    actool
    ibtool
    darwin.autoSignDarwinBinariesHook
    makeWrapper
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    buildDir="$PWD/build"
    mkdir -p "$buildDir"

    commonSwiftFlags=(
      -O -disable-bridging-pch
      -Xlinker -platform_version -Xlinker macos -Xlinker 14.0 -Xlinker 26.0
    )

    nixLog "building Sparkle stub framework"
    swiftc "''${commonSwiftFlags[@]}" -emit-module -emit-library \
      -module-name Sparkle -module-link-name Sparkle \
      -emit-module-path "$buildDir/Sparkle.swiftmodule" \
      -Xlinker -install_name -Xlinker "@rpath/Sparkle.framework/Sparkle" \
      ${./stubs/SparkleStub.swift} -o "$buildDir/libSparkle.dylib"

    nixLog "building MASShortcut framework"
    masDir="${masShortcutSrc}/Framework"
    mkdir -p "$buildDir/MAS_headers/MASShortcut"
    for h in "$masDir"/include/*.h; do
      ln -sf "$h" "$buildDir/MAS_headers/MASShortcut/$(basename "$h")"
    done
    cp ${./stubs/MASShortcut.modulemap} "$buildDir/MAS_headers/MASShortcut/module.modulemap"

    masObjFiles=()
    ${lib.concatMapStrings (
      src:
      let
        name = objName src;
      in
      ''
        nixLog "compiling ${name}"
        clang -fobjc-arc -O2 -I "$masDir/include" -include Foundation/Foundation.h \
          -c "$masDir/${src}" -o "$buildDir/MAS_${name}.o"
        masObjFiles+=("$buildDir/MAS_${name}.o")
      ''
    ) masShortcutSources}

    nixLog "linking MASShortcut dylib"
    clang -dynamiclib "''${masObjFiles[@]}" \
      -framework AppKit -framework Carbon -framework Foundation \
      -install_name "@rpath/MASShortcut.framework/MASShortcut" \
      -o "$buildDir/libMASShortcut.dylib"

    rectSwiftFiles=()
    while IFS= read -r -d "" f; do
      rectSwiftFiles+=("$f")
    done < <(find Rectangle -name '*.swift' -print0)

    nixLog "compiling Rectangle (''${#rectSwiftFiles[@]} swift files)"
    swiftc "''${commonSwiftFlags[@]}" -emit-executable \
      -module-name Rectangle \
      -import-objc-header Rectangle/Rectangle-Bridging-Header.h \
      -I "$buildDir" -L "$buildDir" \
      -Xcc -fmodule-map-file="$buildDir/MAS_headers/MASShortcut/module.modulemap" \
      -Xcc -I"$buildDir/MAS_headers" \
      -lSparkle -lMASShortcut \
      -framework AppKit -framework Cocoa -framework Carbon \
      -framework ServiceManagement -framework IOKit \
      -F /System/Library/PrivateFrameworks \
      -Xlinker -rpath -Xlinker "@executable_path/../Frameworks" \
      "''${rectSwiftFiles[@]}" -o "$buildDir/Rectangle"

    nixLog "compiling RectangleLauncher"
    swiftc "''${commonSwiftFlags[@]}" -emit-executable \
      -module-name RectangleLauncher \
      -parse-as-library \
      -framework AppKit \
      RectangleLauncher/AppDelegate.swift \
      -o "$buildDir/RectangleLauncher"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Compile a .storyboard or .xib into a target resource directory
    # Preserves .lproj subdirectory structure automatically
    compileIB() {
      local src="$1" destDir="$2"
      local filename="$(basename "$src")"
      local name="''${filename%.*}" ext="''${filename##*.}"
      local outExt; if [[ "$ext" == "storyboard" ]]; then outExt="storyboardc"; else outExt="nib"; fi

      local parentDir="$(basename "$(dirname "$src")")"
      nixLog "compiling IB resource: $src"
      if [[ "$parentDir" == *.lproj ]]; then
        mkdir -p "$destDir/$parentDir"
        ibtool --compile "$destDir/$parentDir/$name.$outExt" "$src"
      else
        ibtool --compile "$destDir/$name.$outExt" "$src"
      fi
    }

    # Copy .lproj dirs (for .strings localization files) and strip source IB files
    installLocalizations() {
      local srcDir="$1" destDir="$2"
      nixLog "installing localizations from $srcDir"
      find "$srcDir" -name '*.lproj' -type d -exec cp -r {} "$destDir/" \;
      find "$destDir" \( -name '*.storyboard' -o -name '*.xib' \) -delete
    }

    # Rectangle.app
    app="$out/Applications/Rectangle.app"
    ${mkAppBundle {
      name = "Rectangle";
      binary = "$buildDir/Rectangle";
      sourceDir = "Rectangle";
      plist = mainInfoPlist finalAttrs.version;
      destDir = "$out/Applications";
      frameworks = [
        {
          name = "Sparkle";
          dylib = "$buildDir/libSparkle.dylib";
        }
        {
          name = "MASShortcut";
          dylib = "$buildDir/libMASShortcut.dylib";
          localizations = "${masShortcutSrc}/Framework/Resources";
        }
      ];
    }}

    # Asset catalog
    nixLog "compiling asset catalog"
    actool --compile "$app/Contents/Resources" \
      --platform macosx --minimum-deployment-target 14.0 \
      --app-icon AppIcon --output-partial-info-plist /dev/null \
      Rectangle/Assets.xcassets

    # RectangleLauncher.app
    ${mkAppBundle {
      name = "RectangleLauncher";
      binary = "$buildDir/RectangleLauncher";
      sourceDir = "RectangleLauncher";
      plist = launcherInfoPlist;
      destDir = "$app/Contents/Library/LoginItems";
    }}

    makeWrapper "$app/Contents/MacOS/Rectangle" "$out/bin/rectangle"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Move and resize windows in macOS using keyboard shortcuts or snap areas";
    homepage = "https://rectangleapp.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      FlameFlag
      Intuinewin
      wegank
    ];
    platforms = lib.platforms.darwin;
  };
})
