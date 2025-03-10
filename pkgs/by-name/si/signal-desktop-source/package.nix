{
  stdenv,
  lib,
  nodejs_20,
  pnpm_10,
  electron_33,
  python3,
  makeWrapper,
  libpulseaudio,
  fetchFromGitHub,
  runCommand,
  fetchurl,
  fetchzip,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  nodejs = nodejs_20;
  pnpm = pnpm_10;
  electron = electron_33;

  electron-headers = runCommand "electron-headers" { } ''
    mkdir -p $out
    tar -C $out --strip-components=1 -xvf ${electron.headers}
  '';

  sqlcipher = fetchurl {
    # https://github.com/signalapp/Signal-Sqlcipher-Extension
    url = "https://build-artifacts.signal.org/desktop/sqlcipher-v2-4.6.1-signal-patch2--0.2.1-asm2-6253f886c40e49bf892d5cdc92b2eb200b12cd8d80c48ce5b05967cfd01ee8c7.tar.gz";
    hash = "sha256-YlP4hsQOSb+JLVzckrLrIAsSzY2AxIzlsFlnz9Ae6Mc=";
  };

  ringrtc = stdenv.mkDerivation (finalAttrs: {
    pname = "ringrtc-bin";
    version = "2.50.1";
    src = fetchzip {
      url = "https://build-artifacts.signal.org/libraries/ringrtc-desktop-build-v${finalAttrs.version}.tar.gz";
      hash = "sha256-KHNTw5ScBdYAAyKFdJ6PTmFr+7GYHqgnb4mmNUJZvzM=";
    };

    installPhase = ''
      cp -r . $out
    '';

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ libpulseaudio ];
    meta = {
      homepage = "https://github.com/signalapp/ringrtc";
      license = lib.licenses.agpl3Only;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "signal-desktop-source";
  version = "7.45.1";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "Signal-Desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VtnER2NsVh/YH4V9skq0QQ6daHAqne4mu+wUnGUgb4g=";
  };

  nativeBuildInputs = [
    nodejs
    (pnpm.override { inherit nodejs; }).configHook
    makeWrapper
    copyDesktopItems
    python3
  ];

  patches = [ ./emoji-replace-apple-with-google.patch ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash = "sha256-Mu1kPOr9/0GZIabhV3pjACAkXRmVae8sgoHD/C0Enx0=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    SIGNAL_ENV = "production";
    SOURCE_DATE_EPOCH = 1741560867;
  };

  preBuild = ''
    substituteInPlace node_modules/@signalapp/better-sqlite3/deps/download.js \
      --replace-fail "path.join(__dirname, 'sqlcipher.tar.gz')" "'${sqlcipher}'"

    cp -r ${ringrtc} node_modules/@signalapp/ringrtc/build
  '';

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${electron-headers}
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

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

  meta = {
    description = "Private, simple, and secure messenger (nixpkgs build)";
    longDescription = ''
      Signal Desktop is an Electron application that links with your
      "Signal Android" or "Signal iOS" app.
    '';
    homepage = "https://signal.org/";
    changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      agpl3Only

      # Various npm packages
      free

      # node_modules/emoji-datasource-apple
      unfree
    ];
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

      # sqlcipher
      # ringrtc
      # node_modules/@signalapp/libsignal-client/prebuilds/
      binaryNativeCode
    ];
  };
})
