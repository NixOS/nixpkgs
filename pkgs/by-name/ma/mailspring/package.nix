{
  lib,
  buildNpmPackage,
  callPackage,
  fetchFromGitHub,

  makeBinaryWrapper,
  pkg-config,
  wrapGAppsHook3,

  electron_41,
  html-tidy,

  # Command line arguments which are always set e.g "--password-store=kwallet6"
  commandLineArgs ? "",
}:
let
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "Foundry376";
    repo = "Mailspring";
    tag = version;
    hash = "sha256-32d0WIWqCsZlvuT+RDa3EYxkwTxWzQyLIfASiDfZnL8=";
    fetchSubmodules = true;
  };

  electron = electron_41;

  mailspring-sync = callPackage ./mailsync.nix { inherit src version; };

  mailspring-app = buildNpmPackage {
    pname = "mailspring-app";
    inherit version src;
    sourceRoot = "${src.name}/app";
    npmDepsHash = "sha256-b8CscOVVIbjkdf977LVVzFkWxOwn8XOemYpud5yK6vU=";
    dontNpmBuild = true;
    env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    npmFlags = [ "--ignore-scripts" ];

    makeCacheWritable = true;
    installPhase = ''
      cp -r . "$out"
    '';

    meta = {
      description = "Node dependencies for the Mailspring electron frontend";
      license = lib.licenses.gpl3Plus;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
  };
in
buildNpmPackage (finalAttrs: {
  pname = "mailspring";
  inherit version src;

  npmDepsHash = "sha256-3uidHfxgGONdtwAnoVytIbRqRjwtz3Yu8tNQ0qT8mJQ=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    wrapGAppsHook3
  ];

  npmFlags = [ "--ignore-scripts" ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # Remove the postinstall script to stop it from downloading a recompiled mailspring-sync binary
  postPatch = ''
    echo "" > scripts/postinstall.js
  '';

  preConfigure = ''
    chmod +w app
    cp -r ${mailspring-app}/node_modules app/node_modules
    chmod -R u+w app/node_modules

    cp ${mailspring-sync}/bin/mailsync app/mailsync

    # Remove nix sandbox violating steps from the build script
    substituteInPlace app/build/build.js \
      --replace-fail "runWriteCommitHashIntoPackage," "" \
      --replace-fail "runUpdateSandboxHelperPermissions," "" \
      --replace-fail "runCopySymlinkedPackages," "" \
      --replace-fail "process.argv.includes('--skip-installers')" "true"

    # Use npm env vars to make node-gyp compile against the electron ABI
    export npm_config_target="${electron.version}"
    export npm_config_nodedir="${electron.headers}"

    # Provide a pre-extracted electron dist for @electron/packager.
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    # Force @electron/packager to use our electron instead of downloading it.
    #
    # @electron/packager normally unzips an electron release archive, but its
    # extract-zip dependency intermittently deadlocks mid-extraction on newer
    # node (a lost stream-completion event leaves the build hung forever, see
    # https://github.com/NixOS/nixpkgs/issues/535781). Since we already have an
    # unpacked dist, hand it to @electron/packager directly and turn its
    # extract step into a plain recursive copy, avoiding extract-zip entirely.
    substituteInPlace \
      node_modules/@electron/packager/dist/packager.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "'$(pwd)/electron-dist'"

    substituteInPlace \
      node_modules/@electron/packager/dist/unzip.js \
      --replace-fail "await (0, extract_zip_1.default)(zipPath, { dir: targetDir });" \
      "require('fs').cpSync(zipPath, targetDir, { recursive: true, dereference: true });"

    pushd app
    npm rebuild
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mailspring $out/bin

    ASAR_PATH=$(find app/dist -name "app.asar" -print -quit)
    cp -R "$(dirname "$ASAR_PATH")" $out/share/mailspring/resources

    makeWrapper ${lib.getExe electron} "$out/bin/mailspring" \
      --add-flags "$out/share/mailspring/resources/app.asar" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ html-tidy ]}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  meta = {
    description = "Beautiful, fast and maintained fork of Nylas Mail by one of the original authors";
    downloadPage = "https://github.com/Foundry376/Mailspring/releases";
    changelog = "https://github.com/Foundry376/Mailspring/releases/tag/${finalAttrs.version}";
    homepage = "https://getmailspring.com";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      Mailspring is an open-source mail client forked from Nylas Mail and built with Electron.
      Mailspring's sync engine is open source and written in C++ and C. It runs locally on your computer.
    '';
    mainProgram = "mailspring";
    maintainers = with lib.maintainers; [ wrench-exile-legacy ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
