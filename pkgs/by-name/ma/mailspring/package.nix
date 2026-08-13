{
  lib,
  stdenv,
  buildNpmPackage,
  callPackage,
  fetchFromGitHub,

  actool,
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
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "Foundry376";
    repo = "Mailspring";
    tag = version;
    hash = "sha256-GbY3lov3MT8c8LehEifzOH28VAYpBWDbwXrqEfFfwJg=";
    fetchSubmodules = true;
  };

  patches = [
    ./remove-rpm-deb-and-macos-package-generation.patch
  ];

  electron = electron_41;

  mailspring-sync = callPackage ./mailsync.nix { inherit src version; };

  mailspring-app = buildNpmPackage {
    pname = "mailspring-app";
    inherit version src patches;
    postPatch = "cd app"; # we don't use sourceRoot so that we don't have to make the patch relative to it
    npmDepsHash = "sha256-JkjtC4WT3cBsVlmrfO5WAxU1Xe3vXbxuNBDs2Q7fEck=";
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
        "aarch64-darwin"
      ];
    };
  };
in
buildNpmPackage (finalAttrs: {
  pname = "mailspring";
  inherit version src patches;

  npmDepsHash = "sha256-0cg/DT0MUbfzTq5hejH7auSk77M9Md7FWzidov8iyA4=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    wrapGAppsHook3
    zip
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    actool
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
      --replace-fail "runCopySymlinkedPackages," ""

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

    mkdir -p $out/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''

      mkdir -p $out/share/mailspring
      cp -r app/dist/*/resources $out/share/mailspring

      install -Dm444 app/dist/Mailspring.desktop $out/share/applications/Mailspring.desktop
      install -Dm444 app/dist/mailspring.metainfo.xml $out/share/metainfo/mailspring.metainfo.xml

      for size in 16 32 64 128 256 512; do
        install -Dm444 app/build/resources/linux/icons/$size.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/mailspring.png
      done

    makeWrapper ${lib.getExe electron} "$out/bin/mailspring" \
      --add-flags "$out/share/mailspring/resources/app.asar" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ html-tidy ]}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags ${lib.escapeShellArg commandLineArgs} \
      --inherit-argv0

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''

    mkdir -p $out/Applications
    cp -r app/dist/*/Mailspring.app $out/Applications

    makeWrapper "$out/Applications/Mailspring.app/Contents/MacOS/Mailspring" "$out/bin/mailspring" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  ''
  + ''
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
      "aarch64-darwin"
    ];
  };
})
