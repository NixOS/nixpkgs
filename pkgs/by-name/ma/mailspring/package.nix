{
  lib,
  buildNpmPackage,
  callPackage,
  fetchFromGitHub,

  makeBinaryWrapper,
  pkg-config,
  wrapGAppsHook3,
  zip,

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

  patches = [
    # zip extraction fails on newer nodejs versions without this fix
    ./bump-yauzl.patch
  ];

  electron = electron_41;

  mailspring-sync = callPackage ./mailsync.nix { inherit src version; };

  mailspring-app = buildNpmPackage {
    pname = "mailspring-app";
    inherit version src patches;
    postPatch = "cd app"; # we don't use sourceRoot so that we don't have to make the patch relative to it
    npmDepsHash = "sha256-/caWmbN4Sl3DVPLXSaXrCHEyRsk/p3FwDqSZ7lfNgUk=";
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
      hasNoMaintainersButDependents = true;
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
  inherit version src patches;

  npmDepsHash = "sha256-nHKFuTdk3qbAiSHksSo++mc8TMasspuym7MYxjuTTHI=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    wrapGAppsHook3
    zip
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

    # Create the electron archive to be used by electron-packager
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist

    # force @electron/packager to use our electron instead of downloading it
    substituteInPlace \
      node_modules/@electron/packager/dist/packager.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "'$(pwd)/electron.zip'"

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
