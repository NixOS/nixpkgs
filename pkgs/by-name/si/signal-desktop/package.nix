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
  pnpm = pnpm_10.override { inherit nodejs; };
  electron = electron_35;

  nodeOS =
    {
      "linux" = "linux";
      "darwin" = "darwin";
    }
    .${stdenv.hostPlatform.parsed.kernel.name}
      or (throw "unsupported platform ${stdenv.hostPlatform.parsed.kernel.name}");

  nodeArch =
    {
      # https://nodejs.org/api/os.html#osarch
      "x86_64" = "x64";
      "aarch64" = "arm64";
    }
    .${stdenv.hostPlatform.parsed.cpu.name}
      or (throw "unsupported platform ${stdenv.hostPlatform.parsed.cpu.name}");

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

  version = "7.52.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "Signal-Desktop";
    tag = "v${version}";
    hash = "sha256-dV99PUcXhFwdI6VmS3tuvLYNkPMJOFhxg+lbDqIV7Ms=";
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
      pnpm.configHook
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

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
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
        "sha256-fCA1tBpj0l3Ur9z1o1IAz+HtfDlC5DzPa3m1/8NsFkY="
      else
        "sha256-XQzjctXrpIy1zCWshJY2bA1BvKJ2o2cBA8/ikNYKXok=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    SIGNAL_ENV = "production";
    SOURCE_DATE_EPOCH = 1745425141;
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

    if [ "`jq -r '.dependencies."@signalapp/sqlcipher"' < package.json`" != "${signal-sqlcipher.version}" ]
    then
      die "signal-sqlcipher version mismatch"
    fi

    if [ "`jq -r '.dependencies."@signalapp/ringrtc"' < package.json`" != "${ringrtc.version}" ]
    then
      die "ringrtc version mismatch"
    fi

    mkdir -p node_modules/@signalapp/ringrtc/build
    install -D ${ringrtc}/lib/libringrtc${stdenv.hostPlatform.extensions.library} \
      node_modules/@signalapp/ringrtc/build/${nodeOS}/libringrtc-${nodeArch}.node

    rm -fr node_modules/@signalapp/libsignal-client/prebuilds
    cp -r ${libsignal-node}/lib node_modules/@signalapp/libsignal-client/prebuilds

    rm -fr node_modules/@signalapp/sqlcipher
    cp -r ${signal-sqlcipher} node_modules/@signalapp/sqlcipher
  '';

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${electron.headers}
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
      teutat3s
    ];
    mainProgram = "signal-desktop";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
