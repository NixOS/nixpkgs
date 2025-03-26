{
  stdenv,
  lib,
  nodejs_22,
  pnpm_10,
  electron_35,
  python3,
  makeWrapper,
  callPackage,
  fetchFromGitHub,
  runCommand,
  jq,
  makeDesktopItem,
  copyDesktopItems,
  replaceVars,
  noto-fonts-color-emoji,
  nixosTests,
  withAppleEmojis ? false,
}:
let
  nodejs = nodejs_22;
  pnpm = pnpm_10;
  electron = electron_35;

  electron-headers = runCommand "electron-headers" { } ''
    mkdir -p $out
    tar -C $out --strip-components=1 -xvf ${electron.headers}
  '';

  sqlcipher-signal-extension = callPackage ./sqlcipher-signal-extension.nix { };
  libsignal-node = callPackage ./libsignal-node.nix { inherit nodejs; };

  ringrtc-bin = callPackage ./ringrtc-bin.nix { };

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

  version = "7.48.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "Signal-Desktop";
    tag = "v${version}";
    hash = "sha256-/jtuGsBOFsSgJZNpRilWZ0daI0iYVziZBaF/vLvQ7NU=";
  };

  sticker-creator = stdenv.mkDerivation (finalAttrs: {
    pname = "signal-desktop-sticker-creator";
    inherit version;
    src = src + "/sticker-creator";

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname src version;
      hash = "sha256-TuPyRVNFIlR0A4YHMpQsQ6m+lm2fsp79FzQ1P5qqjIc=";
    };

    nativeBuildInputs = [
      nodejs
      (pnpm.override { inherit nodejs; }).configHook
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
  pname = "signal-desktop-source";
  inherit src version;

  nativeBuildInputs = [
    nodejs
    (pnpm.override { inherit nodejs; }).configHook
    makeWrapper
    copyDesktopItems
    python3
    jq
  ];
  buildInputs = (lib.optional (!withAppleEmojis) noto-fonts-color-emoji-png);

  patches = lib.optional (!withAppleEmojis) (
    replaceVars ./replace-apple-emoji-with-noto-emoji.patch {
      noto-emoji-pngs = "${noto-fonts-color-emoji-png}/share/noto-fonts-color-emoji-png";
    }
  );

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash =
      if withAppleEmojis then
        "sha256-xba5MfIjwnLHDKVM9+2KSpC3gcw6cM4cX3dn3/jqT3o="
      else
        "sha256-I5UGY9Fz4wCa23snq0pir2uq/P+w+fAGU4Bks+CqEgk=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    SIGNAL_ENV = "production";
    SOURCE_DATE_EPOCH = 1743538878;
  };

  preBuild = ''
    if [ "`jq -r '.engines.node' < package.json | head -c 2`" != `head -c 2 <<< "${nodejs.version}"` ]
    then
      die "nodejs version mismatch"
    fi

    if [ "`jq -r '.devDependencies.electron' < package.json | head -c 2`" != `head -c 2 <<< "${electron.version}"` ]
    then
      die "electron version mismatch"
    fi

    if [ "`jq -r '.dependencies."@signalapp/libsignal-client"' < package.json`" != "${libsignal-node.version}" ]
    then
      die "libsignal-client version mismatch"
    fi

    if [ "`jq -r '.dependencies."@signalapp/ringrtc"' < package.json`" != "${ringrtc-bin.version}" ]
    then
      die "ringrtc version mismatch"
    fi

    sqlcipherVersion=${sqlcipher-signal-extension.passthru.sqlcipher-amalgamation.version}
    if ! grep "const SQLCIPHER_VERSION = '$sqlcipherVersion';" \
      node_modules/@signalapp/better-sqlite3/deps/download.js
    then
      die "sqlcipher version mismatch"
    fi

    extensionVersion=${sqlcipher-signal-extension.passthru.signal-sqlcipher-extension.version}
    if ! grep "const EXTENSION_VERSION = '$extensionVersion-asm2';" \
      node_modules/@signalapp/better-sqlite3/deps/download.js
    then
      die "signal-sqlcipher-extension version mismatch"
    fi

    cp ${sqlcipher-signal-extension}/share/sqlite3.gyp node_modules/@signalapp/better-sqlite3/deps/sqlite3.gyp

    cp -r ${ringrtc-bin} node_modules/@signalapp/ringrtc/build

    rm -fr node_modules/@signalapp/libsignal-client/prebuilds
    cp -r ${libsignal-node}/lib node_modules/@signalapp/libsignal-client/prebuilds
  '';

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${electron-headers}
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    cp -r ${sticker-creator} sticker-creator/dist

    pnpm run generate
    pnpm exec electron-builder \
      --dir \
      --config.extraMetadata.environment=$SIGNAL_ENV \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/
    cp -r dist/*-unpacked/resources $out/share/signal-desktop

    for icon in build/icons/png/*
    do
      install -Dm644 $icon $out/share/icons/hicolor/`basename ''${icon%.png}`/apps/signal-desktop.png
    done

    makeWrapper '${lib.getExe electron}' "$out/bin/signal-desktop" \
      --add-flags "$out/share/signal-desktop/app.asar" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
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
      sqlcipher-signal-extension
      libsignal-node
      ringrtc-bin
      sticker-creator
      ;
    tests.application-launch = nixosTests.signal-desktop;
    updateScript.command = [ ./update.sh ];
  };

  meta = {
    description = "Private, simple, and secure messenger (nixpkgs build)";
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
      marcin-serwin
    ];
    mainProgram = "signal-desktop";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource

      # ringrtc
      binaryNativeCode
    ];
  };
})
