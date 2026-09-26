{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  ffmpeg,
  glib,
  glibc,
  gtk3,
  libx11,
  libdrm,
  libnotify,
  libsecret,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  vulkan-loader,
  libglvnd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jlcone";
  version = "1.0.71";

  src = fetchurl {
    url = "https://rs.jlcone.com/static/APP/app_version/jlcone-${finalAttrs.version}.deb";
    sha256 = "sha256-v7hVxUxY1p+gID1SlbASAn012UODsj9WUfPTuNUWlOg=";
  };

  strictDeps = true;
  __structuredAttrs = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    ffmpeg
    glib
    glibc
    gtk3
    libdrm
    libnotify
    libsecret
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    mesa
    nspr
    nss
    pango
    systemd
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
  ];

  unpackPhase = ''
    ar -x $src
    tar -xf data.tar.xz
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out/ 2>/dev/null || true
    cp -r opt/* $out/ 2>/dev/null || true
    cp -r bin/* $out/ 2>/dev/null || true

    substituteInPlace $out/share/applications/jlcone.desktop \
      --replace-fail "/opt/JLCONE" "$out/bin"

    MAIN_BIN=$(find $out -type f -executable -size +10M | head -n1)

    if [ -n "$MAIN_BIN" ]; then
      mkdir -p $out/bin
      ln -sf "$MAIN_BIN" "$out/bin/jlcone"

      # We use lib.makeLibraryPath here
      wrapProgram "$out/bin/jlcone" \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libglvnd
            mesa
            libdrm
            vulkan-loader
            libxkbcommon
            gtk3
            alsa-lib
            nss
            nspr
            expat
            dbus
            at-spi2-core
            pango
            cairo
            libsecret
            libnotify
            systemd
          ]
        }" \
        --add-flags "--no-sandbox"
    fi

    runHook postInstall
  '';

  meta = {
    description = "JLCONE - JLCPCB Desktop Client";
    platforms = [ "x86_64-linux" ];
    homepage = "https://jlcone.com/download";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ cakeforcat ];
    mainProgram = "JLCONE";
  };
})
