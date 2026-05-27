{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  wrapGAppsHook3,
  electron,
  makeDesktopItem,
  copyDesktopItems,
  asar,
  glib,
  nspr,
  nss,
  alsa-lib,
  at-spi2-core,
  cups,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxcb,
  libxshmfence,
  mesa,
  systemd,
  libdrm,
  libgbm,
  zlib,
}:

stdenv.mkDerivation {
  pname = "antigravity-hub";
  version = "2.0.6";
  __structuredAttrs = true;
  strictDeps = true;

  src =
    let
      select = {
        "x86_64-linux" = {
          url = "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.0.6-5413878570549248/linux-x64/Antigravity.tar.gz";
          hash = "sha256-rR4EU1FJsHwnAw6x6tQPTv2jiMs5AgvLuazN+0nkTMU=";
        };
        "aarch64-linux" = {
          url = "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.0.6-5413878570549248/linux-arm/Antigravity.tar.gz";
          hash = "sha256-Avx/R2UFgqxyuEWFO1FN5sg+p6TNio1znhqGiNsvRak=";
        };
      };
    in
    fetchurl
      select."${stdenv.hostPlatform.system}"
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
    asar
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    glib
    nspr
    nss
    alsa-lib
    at-spi2-core
    cups
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
    libxshmfence
    mesa
    systemd
    libdrm
    libgbm
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "antigravity-hub";
      exec = "antigravity-hub";
      icon = "antigravity-hub";
      desktopName = "Antigravity Hub";
      genericName = "Agentic Desktop Application";
      categories = [
        "Utility"
        "Development"
      ];
    })
  ];

  sourceRoot =
    if stdenv.hostPlatform.system == "aarch64-linux" then "Antigravity-arm64" else "Antigravity-x64";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/antigravity-hub
    cp -r resources $out/share/antigravity-hub/

    # Extract original icon from app.asar to install it
    asar extract resources/app.asar extracted-asar
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp extracted-asar/icon.png $out/share/icons/hicolor/512x512/apps/antigravity-hub.png

    # Make the wrapper execution script
    makeWrapper ${electron}/bin/electron $out/bin/antigravity-hub \
      --add-flags "$out/share/antigravity-hub/resources/app.asar" \
      --set CODEIUM_LANGUAGE_SERVER_BIN "$out/share/antigravity-hub/resources/bin/language_server" \
      --inherit-argv0 \
      "''${gappsWrapperArgs[@]}"

    runHook postInstall
  '';

  meta = {
    description = "Google Antigravity Hub - Agentic Desktop Application";
    homepage = "https://antigravity.google";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ lib.maintainers.codebam ];
  };
}
