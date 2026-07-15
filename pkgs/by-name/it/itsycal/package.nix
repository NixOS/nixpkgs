{
  lib,
  stdenv,
  fetchFromGitHub,
  actool,
  ibtool,
  lld,
  makeWrapper,
  rcodesign,
  re-plistbuddy,
  nix-update-script,
}:

let
  # Upstream ships MASShortcut only as a prebuilt framework. Build the
  # maintained Rectangle fork instead; it adds F20 and macOS Tahoe fixes while
  # retaining the API and bundle identity used by Itsycal.
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

  masShortcutInfoPlist = lib.generators.toPlist { escape = true; } {
    CFBundleDevelopmentRegion = "English";
    CFBundleExecutable = "MASShortcut";
    CFBundleIdentifier = "com.github.shpakovski.MASShortcut";
    CFBundleInfoDictionaryVersion = "6.0";
    CFBundleName = "MASShortcut";
    CFBundlePackageType = "FMWK";
    CFBundleShortVersionString = "2.4.0";
    CFBundleVersion = "2.4.0";
    NSHumanReadableCopyright = "Copyright © Vadim Shpakovski. All rights reserved.";
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
    # Use upstream's hidden escape hatch for installations outside /Applications.
    ./0001-Allow-running-from-the-Nix-store.patch
    # Nix owns updates, so remove the otherwise non-functional Sparkle UI.
    ./0002-Remove-self-update-controls-for-Nix-builds.patch
    # Replace the deprecated LSSharedFileList implementation with SMAppService.
    ./0003-Use-modern-ServiceManagement-login-items.patch
    # The Nixpkgs Darwin baseline is macOS 14; use its non-deprecated APIs.
    ./0004-Use-APIs-available-on-the-Nixpkgs-macOS-baseline.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    actool
    ibtool
    lld
    makeWrapper
    rcodesign
    re-plistbuddy
  ];

  # The classic open-source ld64 crashes while linking MASShortcut on arm64.
  # Keep lld until the cctools linker can link this framework reliably.
  env.NIX_CFLAGS_LINK = "-fuse-ld=lld";

  dontConfigure = true;

  postPatch = ''
    # Both upstream frameworks contain native code. MASShortcut is rebuilt
    # below and Sparkle is removed by patch 0002, so make accidental reuse fail.
    rm -rf Itsycal/_frameworks
  '';

  buildPhase = ''
    runHook preBuild

    buildDir="$PWD/build"
    mkdir -p "$buildDir/module-cache"

    # actool accepts one catalog, while upstream keeps images and colors in
    # separate catalogs. Merge them without changing their contents.
    cp -R Itsycal/Images.xcassets "$buildDir/Assets.xcassets"
    cp -R Itsycal/Colors.xcassets/*.colorset "$buildDir/Assets.xcassets/"

    # Compile .m -> .o; flags before --, sources after. Sets _objects array
    compile_objc() {
      local prefix="$1"; shift
      local -a flags=()
      while [[ "$1" != "--" ]]; do flags+=("$1"); shift; done; shift
      _objects=()
      for src in "$@"; do
        local obj="$buildDir/''${prefix}_$(basename "$src" .m).o"
        clang -fobjc-arc "''${flags[@]}" -c "$src" -o "$obj"
        _objects+=("$obj")
      done
    }

    link_dylib() {
      local name="$1"; shift
      clang -dynamiclib -fobjc-arc \
        -install_name "@rpath/$name.framework/$name" "$@"
    }

    # Build MASShortcut as a real framework. The explicit source list avoids
    # pulling its demo or test targets into the application.
    masHeaders="$buildDir/MAS_headers/MASShortcut"
    mkdir -p "$masHeaders"
    cp ${masShortcutSrc}/Framework/include/*.h "$masHeaders/"

    masSources=( ${
      lib.escapeShellArgs (map (src: "${masShortcutSrc}/Framework/${src}") masShortcutSources)
    } )
    compile_objc mas -fmodules -fmodules-cache-path="$buildDir/module-cache" \
      -I"$masHeaders" -include AppKit/AppKit.h -- "''${masSources[@]}"
    link_dylib MASShortcut -framework AppKit -framework Carbon \
      -compatibility_version 1 -current_version 2.4.0 \
      -o "$buildDir/MASShortcut.dylib" "''${_objects[@]}"

    # Itsycal
    compile_objc app -fmodules -fmodules-cache-path="$buildDir/module-cache" \
      -I"$buildDir/MAS_headers" -IItsycal -- Itsycal/*.m
    clang -fobjc-arc \
      -framework AppKit -framework EventKit -framework ScriptingBridge \
      -framework Carbon -framework ServiceManagement -framework UniformTypeIdentifiers \
      -Wl,-rpath,@executable_path/../Frameworks \
      "$buildDir/MASShortcut.dylib" \
      -o "$buildDir/Itsycal" "''${_objects[@]}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    appDir="$out/Applications/Itsycal.app/Contents"
    mkdir -p "$appDir"/{MacOS,Frameworks,Resources}

    cp "$buildDir/Itsycal" "$appDir/MacOS/Itsycal"

    # Assemble the framework bundle metadata normally generated by Xcode.
    mkdir -p "$appDir/Frameworks/MASShortcut.framework/Resources"
    cp "$buildDir/MASShortcut.dylib" "$appDir/Frameworks/MASShortcut.framework/MASShortcut"
    cp -r ${masShortcutSrc}/Framework/Resources/*.lproj "$appDir/Frameworks/MASShortcut.framework/Resources/"
    printf '%s' ${lib.escapeShellArg masShortcutInfoPlist} \
      > "$appDir/Frameworks/MASShortcut.framework/Resources/Info.plist"

    # Resources
    ibtool --compile "$appDir/Resources/MainMenu.nib" Itsycal/Base.lproj/MainMenu.xib
    actool --compile "$appDir/Resources" \
      --platform macosx \
      --minimum-deployment-target ${stdenv.hostPlatform.darwinMinVersion} \
      --app-icon AppIcon \
      --output-partial-info-plist "$buildDir/asset-info.plist" \
      "$buildDir/Assets.xcassets"
    cp Itsycal/beep.mp3 "$appDir/Resources/"
    mkdir -p "$appDir/Resources/Fonts"
    cp Itsycal/_fonts/Mow.otf "$appDir/Resources/Fonts/"
    for lproj in Itsycal/*.lproj; do
      mkdir -p "$appDir/Resources/$(basename "$lproj")"
      cp "$lproj"/*.strings "$appDir/Resources/$(basename "$lproj")/" 2>/dev/null || true
    done

    # Resolve the Xcode variables in upstream's plist. Keeping that plist as
    # the source of truth means new privacy and bundle metadata is preserved.
    bundleVersion=$(sed -n 's/.*CURRENT_PROJECT_VERSION = \([0-9]*\);/\1/p' \
      Itsycal.xcodeproj/project.pbxproj | head -1)
    cp Itsycal/Info.plist "$appDir/Info.plist"
    substituteInPlace "$appDir/Info.plist" \
      --replace-fail '$(EXECUTABLE_NAME)' 'Itsycal' \
      --replace-fail '$(PRODUCT_BUNDLE_IDENTIFIER)' 'com.mowglii.ItsycalApp' \
      --replace-fail '$(PRODUCT_NAME)' 'Itsycal' \
      --replace-fail '$(MARKETING_VERSION)' '${finalAttrs.version}' \
      --replace-fail '$(CURRENT_PROJECT_VERSION)' "$bundleVersion" \
      --replace-fail '$(MACOSX_DEPLOYMENT_TARGET)' '${stdenv.hostPlatform.darwinMinVersion}'

    # Merge actool's icon metadata and remove the Sparkle configuration that
    # no longer has a consumer in this immutable Nix build.
    PlistBuddy -c 'Set :CFBundleIconFile AppIcon' \
      -c 'Add :CFBundleIconName string AppIcon' \
      -c 'Delete :SUAllowsAutomaticUpdates' \
      -c 'Delete :SUEnableAutomaticChecks' \
      -c 'Delete :SUFeedURL' \
      -c 'Delete :SUPublicEDKey' \
      -c 'Delete :SUScheduledCheckInterval' \
      "$appDir/Info.plist"

    makeWrapper "$out/Applications/Itsycal.app/Contents/MacOS/Itsycal" "$out/bin/itsycal"

    runHook postInstall
  '';

  # Signing only Mach-O files leaves app resources unsealed. Sign the complete
  # bundle after fixup so ServiceManagement accepts it and nested code verifies.
  postFixup = ''
    rcodesign sign "$out/Applications/Itsycal.app"
  '';

  passthru.updateScript = nix-update-script {
    # Ignore upstream's non-version "help" tag.
    extraArgs = [ "--version-regex=^([0-9]+\\.[0-9]+\\.[0-9]+)$" ];
  };

  meta = {
    changelog = "https://www.mowglii.com/itsycal/versionhistory.html";
    description = "Tiny menu bar calendar";
    homepage = "https://www.mowglii.com/itsycal/";
    license = with lib.licenses; [
      bsd2
      mit
    ];
    mainProgram = "itsycal";
    maintainers = with lib.maintainers; [
      eclairevoyant
      _4evy
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
