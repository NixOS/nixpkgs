{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  gtk3,
  nss,
  libsecret,
  libsoup_3,
  gdk-pixbuf,
  glib,
  webkitgtk_4_1,
  xdg-utils,
}:

let
  version = "2026.01.12.e43ec47";
  versionHyphenated = "2026.01.12-e43ec47";

  sources = {
    x86_64-linux = {
      url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-${versionHyphenated}.zip";
      hash = "sha256-OtfhmPQPmmrwp/1XYcbefj6PMxEEbOE5RSTECCZaguc=";
    };
    aarch64-darwin = {
      url = "https://launcher.hytale.com/builds/release/darwin/arm64/hytale-launcher-${versionHyphenated}.zip";
      hash = "sha256-2+RCO1dqK6AGSPy/tFVvMeETUuuughwNznvGENPobew=";
    };
  };

  currentSource =
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "hytale-launcher";
  inherit version;

  src = fetchzip {
    inherit (currentSource) url hash;
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    nss
    libsecret
    libsoup_3
    gdk-pixbuf
    glib
    webkitgtk_4_1
  ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "hytale-launcher";
      exec = "hytale-launcher";
      desktopName = "Hytale Launcher";
      categories = [ "Game" ];
      terminal = false;
    })
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p "$out/bin"

    install -Dm755 "hytale-launcher" "$out/bin/hytale-launcher"

    wrapProgram "$out/bin/hytale-launcher" \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --set __NV_DISABLE_EXPLICIT_SYNC 1 \
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
      --set DESKTOP_STARTUP_ID com.hypixel.HytaleLauncher
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications" "$out/bin"
    cp -r hytale-launcher.app "$out/Applications/"
    makeWrapper "$out/Applications/hytale-launcher.app/Contents/MacOS/hytale-launcher" "$out/bin/hytale-launcher"
  ''
  + ''
    runHook postInstall
  '';

  meta = {
    description = "Official launcher for Hytale";
    homepage = "https://hytale.com";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ karol-broda ];
    mainProgram = "hytale-launcher";
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
