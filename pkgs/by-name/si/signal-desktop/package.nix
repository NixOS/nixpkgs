{
  stdenv,
  lib,
  nodejs_24,
  pnpm_10_29_2,
  fetchPnpmDeps,
  pnpmConfigHook,
  electron_40,
  python3,
  makeWrapper,
  callPackage,
  fetchFromGitHub,
  jq,
  makeDesktopItem,
  copyDesktopItems,
  xcodebuild,
  replaceVars,
  noto-fonts-color-emoji,
  nixosTests,

  # command line arguments which are always set e.g "--password-store=kwallet6"
  commandLineArgs ? "",

  withAppleEmojis ? false,
}:
assert lib.warnIf (commandLineArgs != "")
  "`commandLineArgs` has been deprecated and will be removed in the future. Consider creating a wrapper script or a desktop entry with your desired flags."
  true;
let
  nodejs = nodejs_24;
  pnpm = pnpm_10_29_2;
  electron = electron_40;

  libsignal-node = callPackage ./libsignal-node.nix { inherit nodejs; };
  signal-sqlcipher = callPackage ./signal-sqlcipher.nix { inherit pnpm nodejs; };

  webrtc = callPackage ./webrtc.nix { };
  ringrtc = callPackage ./ringrtc.nix { inherit webrtc; };

  # Noto Color Emoji PNG files for emoji replacement; see below.
  noto-fonts-color-emoji-png = noto-fonts-color-emoji.overrideAttrs (prevAttrs: {
    pname = "noto-fonts-color-emoji-png";

    # The build produces 136×128 PNGs by default for arcane font
    # reasons, but we want square PNGs.
    buildFlags = prevAttrs.buildFlags or [ ] ++ [ "BODY_DIMENSIONS=128x128" ];

    makeTargets = [ "compressed" ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      mv build/compressed_pngs $out/share/noto-fonts-color-emoji-png
      python3 add_aliases.py --srcdir=$out/share/noto-fonts-color-emoji-png

      runHook postInstall
    '';
  });

  version = "8.6.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "Signal-Desktop";
    tag = "v${version}";
    hash = "sha256-K6mufC7LFGWeCkIkrsYPO2n/0L1b6yBqiLcv7w7e57g=";
  };

  sticker-creator = stdenv.mkDerivation (finalAttrs: {
    pname = "signal-desktop-sticker-creator";
    inherit version;
    src = src + "/sticker-creator";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname src version;
      inherit pnpm;
      fetcherVersion = 3;
      hash = "sha256-WbdYcI5y01gdS9AIzy4VZZ6eFaTHaVPscTawLSsHzlc=";
    };

    strictDeps = true;
    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    buildPhase = ''
      runHook preBuild
      pnpm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "signal-desktop";
  inherit src version;

  strictDeps = true;
  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeWrapper
    python3
    jq
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcodebuild
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  patches = [
    ./force-90-days-expiration.patch
  ]
  ++ lib.optional (!withAppleEmojis) (
    # Signal ships the Apple emoji set without a licence via an npm
    # package and upstream does not seem terribly interested in fixing
    # this; see:
    #
    # * <https://github.com/signalapp/Signal-Android/issues/5862>
    # * <https://whispersystems.discoursehosting.net/t/signal-is-likely-violating-apple-license-terms-by-using-apple-emoji-in-the-sticker-creator-and-android-and-desktop-apps/52883>
    #
    # We work around this by replacing it with the Noto Color Emoji
    # set, which is available under a FOSS licence and more likely to
    # be used on a NixOS machine anyway. The Apple emoji are removed
    # before `fetchPnpmDeps` to ensure that the build doesn’t cache the
    # unlicensed emoji files.
    replaceVars ./replace-apple-emoji-with-noto-emoji.patch {
      noto-emoji-pngs = "${noto-fonts-color-emoji-png}/share/noto-fonts-color-emoji-png";
    }
  );

  postPatch = ''
    # The spell checker dictionary URL interpolates the electron version,
    # however, the official website only provides dictionaries for electron
    # versions which they vendor into the binary releases. Since we unpin
    # electron to use the one from nixpkgs the URL may point to nonexistent
    # resource if the nixpkgs version is different. To fix this we hardcode
    # the electron version to the declared one here instead of interpolating
    # it at runtime.
    substituteInPlace app/updateDefaultSession.main.ts \
      --replace-fail "\''${process.versions.electron}" "`jq -r '.devDependencies.electron' < package.json`"

    # Disable auto-updater https://github.com/signalapp/Signal-Desktop/issues/7667
    substituteInPlace config/production.json \
      --replace-fail '"updatesEnabled": true' '"updatesEnabled": false'

    # Nix builds do not need upstream release hooks (notarization and
    # language-pack postprocessing), and they expect a different macOS
    # app layout than nixpkgs' Electron provides.
    substituteInPlace package.json \
      --replace-fail '"artifactBuildCompleted": "ts/scripts/artifact-build-completed.node.ts",' "" \
      --replace-fail '"afterSign": "ts/scripts/after-sign.node.ts",' "" \
      --replace-fail '"afterPack": "ts/scripts/after-pack.node.ts",' "" \
      --replace-fail '"sign": "./ts/scripts/sign-macos.node.ts",' "" \
      --replace-fail '"afterAllArtifactBuild": "ts/scripts/after-all-artifact-build.node.ts",' ""
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash =
      if withAppleEmojis then
        "sha256-d6ul6MTJhnM4PyxMlMaVovnvSPfYh3DmMjHjmOideB4="
      else
        "sha256-JymcPdFMi0wfceOJnPrwEBG4PnosIFnrxiIrTlcGf/g=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    SIGNAL_ENV = "production";
    SOURCE_DATE_EPOCH = 1775687068;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Disable code signing during local macOS builds.
    CSC_IDENTITY_AUTO_DISCOVERY = "false";
  };

  preBuild = ''
    if [ "`jq -r '.engines.node' < package.json | cut -d. -f1`" != "${lib.versions.major nodejs.version}" ]
    then
      die "nodejs version mismatch"
    fi

    if [ "`jq -r '.devDependencies.electron' < package.json | cut -d. -f1`" != "${lib.versions.major electron.version}" ]
    then
      die "electron version mismatch"
    fi

    if [ "`jq -r '.dependencies."@signalapp/libsignal-client"' < package.json`" != "${libsignal-node.version}" ]
    then
      die "libsignal-client version mismatch"
    fi

    if [ "`jq -r '.dependencies."@signalapp/sqlcipher"' < package.json`" != "${signal-sqlcipher.version}" ]
    then
      die "signal-sqlcipher version mismatch"
    fi

    if [ "`jq -r '.dependencies."@signalapp/ringrtc"' < package.json`" != "${ringrtc.version}" ]
    then
      die "ringrtc version mismatch"
    fi

    install -D ${ringrtc}/lib/libringrtc${stdenv.hostPlatform.extensions.library} \
      node_modules/@signalapp/ringrtc/build/libringrtc.node

    substituteInPlace package.json \
      --replace-fail '"node_modules/@signalapp/ringrtc/build/''${platform}/*''${arch}*.node",' \
                     '"node_modules/@signalapp/ringrtc/build/libringrtc.node",'

    substituteInPlace node_modules/@signalapp/ringrtc/dist/ringrtc/Native.js \
      --replace-fail 'exports.default = require(`../../build/''${os.platform()}/libringrtc-''${process.arch}.node`);' \
                     'exports.default = require(`../../build/libringrtc.node`);'

    rm -r node_modules/@signalapp/libsignal-client/prebuilds
    cp -r ${libsignal-node}/lib node_modules/@signalapp/libsignal-client/prebuilds

    rm -r node_modules/@signalapp/sqlcipher
    cp -r ${signal-sqlcipher} node_modules/@signalapp/sqlcipher

    # fs-xattr is required at runtime by preload.wrapper.js,
    # but with npmRebuild disabled its native binding is missing.
    # Build it explicitly against Electron headers ahead of packaging.
    export npm_config_nodedir=${electron.headers}
    pushd node_modules/fs-xattr
    pnpm exec node-gyp rebuild
    popd
    test -f node_modules/fs-xattr/build/Release/xattr.node
  '';

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${electron.headers}
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    cp -r ${sticker-creator} sticker-creator/dist

    pnpm run generate
    pnpm exec electron-builder \
      ${
        if stdenv.hostPlatform.isDarwin then "--mac" else "--linux"
      } "dir:${stdenv.hostPlatform.node.arch}" \
      --config.extraMetadata.environment=$SIGNAL_ENV \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-c.mac.identity=null"}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -r dist/mac*/Signal.app $out/Applications
    makeWrapper "$out/Applications/Signal.app/Contents/MacOS/Signal" "$out/bin/signal-desktop" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p $out/share
    cp -r dist/*-unpacked/resources $out/share/signal-desktop

    for icon in build/icons/png/*
    do
      install -Dm644 $icon $out/share/icons/hicolor/`basename ''${icon%.png}`/apps/signal-desktop.png
    done

    makeWrapper '${lib.getExe electron}' "$out/bin/signal-desktop" \
      --add-flags "$out/share/signal-desktop/app.asar" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "signal";
      desktopName = "Signal";
      exec = "${finalAttrs.meta.mainProgram} %U";
      type = "Application";
      terminal = false;
      icon = "signal-desktop";
      comment = "Private messaging from your desktop";
      startupWMClass = "signal";
      mimeTypes = [
        "x-scheme-handler/sgnl"
        "x-scheme-handler/signalcaptcha"
      ];
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
    })
  ];

  passthru = {
    inherit
      libsignal-node
      ringrtc
      webrtc
      sticker-creator
      signal-sqlcipher
      ;
    tests.application-launch = nixosTests.signal-desktop;
    updateScript.command = [ ./update.sh ];
  };

  meta = {
    description = "Private, simple, and secure messenger";
    longDescription = ''
      Signal Desktop is an Electron application that links with your
      "Signal Android" or "Signal iOS" app.
    '';
    homepage = "https://signal.org/";
    changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      [
        agpl3Only

        # Various npm packages
        free
      ]
      ++ lib.optional withAppleEmojis unfree;
    maintainers = with lib.maintainers; [
      eclairevoyant
      iamanaws
      marcin-serwin
      teutat3s
    ];
    mainProgram = "signal-desktop";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
