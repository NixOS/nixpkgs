{
  alsa-lib,
  atk,
  cairo,
  cups,
  curl,
  dbus,
  dpkg,
  expat,
  fetchurl,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  gtk4,
  lib,
  libX11,
  libxcb,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libdrm,
  libnotify,
  libpulseaudio,
  libuuid,
  libxshmfence,
  libgbm,
  nspr,
  nss,
  pango,
  stdenv,
  systemd,
  at-spi2-atk,
  at-spi2-core,
  autoPatchelfHook,
  wrapGAppsHook3,
  qt6,
  proprietaryCodecs ? false,
  vivaldi-ffmpeg-codecs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opera";
  version = "121.0.5600.50";

  src = fetchurl {
    url = "${"https://get.geo.opera.com/pub/opera/desktop"}/${finalAttrs.version}/linux/opera-stable_${finalAttrs.version}_amd64.deb";
    hash = "sha256-mUSUVWEdcSrwbWY8XFFAHrS7nagcXnNoLOqS8oL09Cc=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig.lib
    freetype
    gdk-pixbuf
    glib
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libdrm
    libnotify
    libuuid
    libxcb
    libxshmfence
    libgbm
    nspr
    nss
    pango
    (lib.getLib stdenv.cc.cc)
    qt6.qtbase
  ];

  runtimeDependencies = [
    # Works fine without this except there is no sound.
    libpulseaudio.out

    # This is a little tricky. Without it the app starts then crashes. Then it
    # brings up the crash report, which also crashes. `strace -f` hints at a
    # missing libudev.so.0.
    (lib.getLib systemd)

    # Error at startup:
    # "Illegal instruction (core dumped)"
    gtk3
    gtk4
  ]
  ++ lib.optionals proprietaryCodecs [ vivaldi-ffmpeg-codecs ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r usr $out
    cp -r usr/share $out/share
    # we already using QT6, autopatchelf wants to patch this as well
    rm $out/usr/lib/x86_64-linux-gnu/opera/libqt5_shim.so
    ln -s $out/usr/bin/opera $out/bin/opera
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.opera.com";
    description = "Faster, safer and smarter web browser";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ vunnyso ];
  };
})
