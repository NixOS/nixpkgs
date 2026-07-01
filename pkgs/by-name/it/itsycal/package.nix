{
  lib,
  stdenv,
  fetchFromGitHub,
  ibtool,
  makeWrapper,
  re-plistbuddy,
  darwin,
  nix-update-script,
}:

let
  masShortcutSrc = fetchFromGitHub {
    owner = "shpakovski";
    repo = "MASShortcut";
    rev = "6f2603c6b6cc18f64a799e5d2c9d3bbc467c413a";
    hash = "sha256-RTT6mGpN3B+0Xcm252dos3uGrlLuBMHgB74aeGSZ5dI=";
  };

  infoPlist =
    version:
    lib.generators.toPlist { escape = true; } {
      ATSApplicationFontsPath = "Fonts";
      CFBundleAllowMixedLocalizations = true;
      CFBundleDevelopmentRegion = "en";
      CFBundleExecutable = "Itsycal";
      CFBundleIconFile = "";
      CFBundleIdentifier = "com.mowglii.ItsycalApp";
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundleName = "Itsycal";
      CFBundlePackageType = "APPL";
      CFBundleShortVersionString = version;
      CFBundleSignature = "????";
      CFBundleURLTypes = [
        {
          CFBundleTypeRole = "Viewer";
          CFBundleURLName = "com.mowglii.ItsycalApp";
          CFBundleURLSchemes = [ "itsycal" ];
        }
      ];
      # CFBundleVersion is spliced from the Xcode project at build time
      LSApplicationCategoryType = "public.app-category.utilities";
      LSMinimumSystemVersion = "11.0";
      LSUIElement = true;
      NSAppleEventsUsageDescription = "Itsycal uses AppleEvents to open your calendar app to the selected day.";
      NSCalendarsFullAccessUsageDescription = "Itsycal is more useful when it can display events from your calendars.";
      NSCalendarsUsageDescription = "Itsycal is more useful when it can display events from your calendars.";
      NSHumanReadableCopyright = "© 2012 − 2025 mowglii.com";
      NSMainNibFile = "MainMenu";
      NSPrincipalClass = "NSApplication";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "itsycal";
  version = "0.15.12";

  src = fetchFromGitHub {
    owner = "sfsam";
    repo = "Itsycal";
    tag = finalAttrs.version;
    hash = "sha256-K25oG8d+OauNHLkatLLskfcWCqOmM2WEw2Ygd3v1uqE=";
  };

  patches = [
    # viraptor's actool produces .car files that trigger BOMStream buffer
    # overflows in CoreUI, so we use loose PNGs instead of a compiled asset
    # catalog. This loses xcassets metadata that we restore with patches:
    #  - named colors (hardcoded as dynamic NSColor providers)
    #  - template-rendering-intent (set programmatically)
    ./hardcode-named-colors.patch
    ./mark-template-images.patch
  ];

  nativeBuildInputs = [
    ibtool
    makeWrapper
    re-plistbuddy
    darwin.autoSignDarwinBinariesHook
  ];

  postPatch = ''
    substituteInPlace Itsycal/AppDelegate.m \
      --replace-fail '[self checkIfRunFromApplicationsFolder];' '/* removed for Nix */' \
      --replace-fail 'kEnableTahoeMenuIcons: @(NO)' 'kEnableTahoeMenuIcons: @(YES)'
  '';

  buildPhase = ''
    runHook preBuild

    buildDir="$PWD/build"
    mkdir -p "$buildDir/module-cache"

    # Compile .m -> .o; flags before --, sources after. Sets _objects array
    compile_objc() {
      local prefix="$1"; shift
      local -a flags=()
      while [[ "$1" != "--" ]]; do flags+=("$1"); shift; done; shift
      _objects=()
      for src in "$@"; do
        local obj="$buildDir/''${prefix}_$(basename "$src" .m).o"
        clang -fobjc-arc -mmacosx-version-min=11.0 "''${flags[@]}" -c "$src" -o "$obj"
        _objects+=("$obj")
      done
    }

    link_dylib() {
      local name="$1"; shift
      clang -dynamiclib -fobjc-arc -mmacosx-version-min=11.0 \
        -install_name "@rpath/$name.framework/$name" "$@"
    }

    # MASShortcut
    masHeaders="$buildDir/MAS_headers/MASShortcut"
    mkdir -p "$masHeaders"
    find ${masShortcutSrc}/Framework -name '*.h' -exec cp -f {} "$masHeaders/" \;

    readarray -d "" -t masSources < <(find ${masShortcutSrc}/Framework -name '*.m' ! -name '*Tests.m' -print0)
    compile_objc mas -I"$masHeaders" -include AppKit/AppKit.h -- "''${masSources[@]}"
    link_dylib MASShortcut -framework AppKit -framework Carbon \
      -o "$buildDir/MASShortcut.dylib" "''${_objects[@]}"

    # Sparkle stub
    mkdir -p "$buildDir/Sparkle_headers/Sparkle"
    cp ${./stubs/SparkleStub.h} "$buildDir/Sparkle_headers/Sparkle/SUUpdater.h"

    compile_objc sparkle -I"$buildDir/Sparkle_headers" -- ${./stubs/SparkleStub.m}
    link_dylib Sparkle -framework Foundation \
      -o "$buildDir/Sparkle.dylib" "''${_objects[@]}"

    # Itsycal
    compile_objc app -fmodules -fmodules-cache-path="$buildDir/module-cache" \
      -I"$buildDir/MAS_headers" -I"$buildDir/Sparkle_headers" -IItsycal -- Itsycal/*.m
    clang -fobjc-arc -mmacosx-version-min=11.0 \
      -Wl,-platform_version,macos,11.0,26.0 \
      -framework AppKit -framework EventKit -framework ScriptingBridge \
      -framework Carbon -framework ServiceManagement \
      -Wl,-rpath,@executable_path/../Frameworks \
      "$buildDir/MASShortcut.dylib" "$buildDir/Sparkle.dylib" \
      -o "$buildDir/Itsycal" "''${_objects[@]}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    appDir="$out/Applications/Itsycal.app/Contents"
    mkdir -p "$appDir"/{MacOS,Frameworks,Resources}

    cp "$buildDir/Itsycal" "$appDir/MacOS/Itsycal"

    # Frameworks
    mkdir -p "$appDir/Frameworks/MASShortcut.framework/Resources"
    cp "$buildDir/MASShortcut.dylib" "$appDir/Frameworks/MASShortcut.framework/MASShortcut"
    cp -r ${masShortcutSrc}/Framework/Resources/*.lproj "$appDir/Frameworks/MASShortcut.framework/Resources/"
    mkdir -p "$appDir/Frameworks/Sparkle.framework"
    cp "$buildDir/Sparkle.dylib" "$appDir/Frameworks/Sparkle.framework/Sparkle"

    # Resources
    ibtool --compile "$appDir/Resources/MainMenu.nib" Itsycal/Base.lproj/MainMenu.xib
    find Itsycal/Images.xcassets -name '*.png' -exec cp {} "$appDir/Resources/" \;
    mkdir -p "$appDir/Resources/Fonts"
    cp Itsycal/_fonts/Mow.otf "$appDir/Resources/Fonts/"
    for lproj in Itsycal/*.lproj; do
      mkdir -p "$appDir/Resources/$(basename "$lproj")"
      cp "$lproj"/*.strings "$appDir/Resources/$(basename "$lproj")/" 2>/dev/null || true
    done

    cat > "$appDir/Info.plist" << 'PLIST'
    ${infoPlist finalAttrs.version}
    PLIST

    # Splice CFBundleVersion from the Xcode project so it stays in sync
    # automatically when nix-update-script bumps the tag
    bundleVersion=$(sed -n 's/.*CURRENT_PROJECT_VERSION = \([0-9]*\);/\1/p' \
      Itsycal.xcodeproj/project.pbxproj | head -1)
    PlistBuddy -c "Add :CFBundleVersion string $bundleVersion" "$appDir/Info.plist"

    makeWrapper "$out/Applications/Itsycal.app/Contents/MacOS/Itsycal" "$out/bin/itsycal"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://www.mowglii.com/itsycal/versionhistory.html";
    description = "Tiny menu bar calendar";
    homepage = "https://www.mowglii.com/itsycal/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      eclairevoyant
      FlameFlag
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
