{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  glib,
  gtk3,
  libdrm,
  libnotify,
  libuuid,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  wayland,
  libva,
  curl,
  libGL,
  xorg,
  vivaldi-ffmpeg-codecs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opera";
  version = "129.0.5823.28";

  src = fetchurl {
    url = "https://get.geo.opera.com/pub/opera/desktop/${finalAttrs.version}/linux/opera-stable_${finalAttrs.version}_amd64.deb";
    hash = "sha256-1hIxbv0tU6SnGDFu4fN+syt1sbASfJnZwmQXao/ehIY=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    glib
    gtk3
    libdrm
    libnotify
    libuuid
    mesa
    nspr
    nss
    pango
    systemd
    wayland
    libva
    curl
    libGL
    vivaldi-ffmpeg-codecs
  ]
  ++ (with xorg; [
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
    libxcb
  ]);

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Widgets.so.5"
    "libQt5Gui.so.5"
    "libQt5Core.so.5"
    "libQt6Widgets.so.6"
    "libQt6Gui.so.6"
    "libQt6Core.so.6"
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out/

    mkdir -p $out/lib/x86_64-linux-gnu/opera/
    ln -sf ${vivaldi-ffmpeg-codecs}/lib/libffmpeg.so $out/lib/x86_64-linux-gnu/opera/libffmpeg.so

    wrapProgram $out/bin/opera \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --add-flags "--ffmpeg-directory=${vivaldi-ffmpeg-codecs}/lib" \
      --add-flags "--password-store=basic"

    substituteInPlace $out/share/applications/opera.desktop \
      --replace "Exec=opera" "Exec=$out/bin/opera"

    runHook postInstall
  '';

  meta = {
    description = "Opera web browser";
    homepage = "https://www.opera.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ laurids ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "opera";
  };
})
