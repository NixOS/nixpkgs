{
  lib,
  stdenv,
  fetchFromGitHub,
  swift,
  swiftpm,
  fetchSwiftPMDeps,
  apple-sdk_26,
  darwinMinVersionHook,
  installShellFiles,
  jq,
  python3,
  rcodesign,
  sqlite,
  zlib,
  versionCheckHook,
  nix-update-script,
}:

let
  # Sparkle's in-app updater is left out (see RURI_DISABLE_SPARKLE below), so
  # its prebuilt framework is neither fetched nor resolved.
  removeSparklePin = ''
    jq 'del(.pins[] | select(.identity == "sparkle"))' Package.resolved > Package.resolved.new
    mv Package.resolved.new Package.resolved
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ruri-launcher";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "guh0613";
    repo = "ruri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+NKv6VIN1TUQMur8Pw3B6t9hhlVt1R8Ds28ndxYGUHw=";
  };

  postPatch = removeSparklePin;

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    postPatch = removeSparklePin;
    hash = "sha256-EFRLefyZyq/VBUoe5cOeiDlc5+NsqTxTE2fp8KovsDw=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    swift
    swiftpm
    installShellFiles
    jq
    python3
    rcodesign
  ];

  buildInputs = [
    apple-sdk_26
    (darwinMinVersionHook "14.0")
    sqlite
    zlib
  ];

  env = {
    RURI_DISABLE_SPARKLE = "1";
    # Hides the app's own command-line link, since the package puts `ruri` on PATH
    RURI_PACKAGE_MANAGER = "Nix";
    # The release CurseForge key is not public; users can add their own in Settings
    RURI_CURSEFORGE_API_KEY = "";
  };

  # SwiftPM builds the Swift products; the rest follows upstream's nix/package.nix
  postBuild = ''
    mkdir -p build/game-host
    # Universal, so the same host can load native or Rosetta Java
    hostFlags=(-mmacosx-version-min=14.0 -arch arm64 -arch x86_64 -fobjc-arc -O2 -Wall -Wextra -Werror)
    $CC "''${hostFlags[@]}" -dynamiclib -framework Foundation Sources/RuriGameHost/WorkingDirectory.m \
      -install_name @rpath/libRuriGameSupport.dylib -o build/game-host/libRuriGameSupport.dylib
    $CC "''${hostFlags[@]}" -framework AppKit -framework ImageIO \
      Sources/RuriGameHost/main.m Sources/RuriGameHost/HostProtocol.m Sources/RuriGameHost/GameApplication.m \
      -Lbuild/game-host -lRuriGameSupport -Wl,-rpath,@executable_path/../Frameworks -o build/game-host/ruri-game
  '';

  installPhase = ''
    runHook preInstall

    binPath="$(swiftpmBinPath)"
    app="$out/Applications/Ruri.app"
    mkdir -p "$app/Contents/MacOS" "$app/Contents/Helpers" "$app/Contents/Resources"

    cp Resources/Info.plist "$app/Contents/Info.plist"
    # Upstream ships the icons compiled by Xcode's actool
    cp Resources/ThirdPartyNotices.txt nix/icons/AppIcon/* "$app/Contents/Resources/"
    python3 scripts/lib/app.py bundle "$app"

    install -m755 "$binPath/Ruri" "$app/Contents/MacOS/Ruri"
    install -m755 "$binPath/ruri-cli" "$binPath/ruri-monitor" "$app/Contents/Helpers/"
    # Like release builds, drop the symbol tables: about half of each executable
    $STRIP "$app/Contents/MacOS/Ruri" "$app/Contents/Helpers/ruri-cli" "$app/Contents/Helpers/ruri-monitor"
    cp -R "$binPath"/*.bundle "$app/Contents/Resources/"
    # Xcode compiles the String Catalogs that SwiftPM copies as-is
    python3 scripts/localization.py --compile "$app/Contents/Resources/Ruri_RuriLocalization.bundle"

    host="$app/Contents/Helpers/RuriGame.app"
    install -Dm644 Resources/GameHost-Info.plist "$host/Contents/Info.plist"
    install -Dm755 build/game-host/ruri-game "$host/Contents/MacOS/ruri-game"
    install -Dm755 build/game-host/libRuriGameSupport.dylib "$host/Contents/Frameworks/libRuriGameSupport.dylib"
    install -Dm644 -t "$host/Contents/Resources" nix/icons/GameHostIcon/*

    # The CLI finds the app's resources and helpers through this link
    mkdir -p "$out/bin"
    ln -s "$app/Contents/Helpers/ruri-cli" "$out/bin/ruri"

    runHook postInstall
  '';

  # Sign after fixup has stripped the binaries and rewritten their rpaths; the
  # CLI shares the launcher's identifier
  postFixup = ''
    rcodesign sign \
      --binary-identifier Contents/Helpers/ruri-cli:dev.ruri.launcher \
      "$out/Applications/Ruri.app"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ruri \
      --bash <("$out/bin/ruri" completions bash) \
      --fish <("$out/bin/ruri" completions fish) \
      --zsh <("$out/bin/ruri" completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  postInstallCheck = ''
    python3 scripts/localization.py --bundle "$out/Applications/Ruri.app"
  '';

  passthru = {
    # nix-update does not detect SwiftPM dependencies automatically
    swiftpmVendor = finalAttrs.swiftpmDeps.vendorStaging;
    updateScript = nix-update-script {
      extraArgs = [
        "--custom-dep"
        "swiftpmVendor"
      ];
    };
  };

  meta = {
    description = "Minecraft: Java Edition launcher for macOS";
    homepage = "https://github.com/guh0613/ruri";
    changelog = "https://github.com/guh0613/ruri/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HCHogan ];
    mainProgram = "ruri";
    platforms = [ "aarch64-darwin" ];
    # The prebuilt icons are asset catalogs, not native code
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
