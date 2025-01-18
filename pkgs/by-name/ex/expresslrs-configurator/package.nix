{
  stdenv,
  fetchzip,
  autoPatchelfHook,
  lib,
  makeWrapper,
  electron_33,
  libgcc,
  libstdcxx5,
  musl,
  libxc,
  libxkbcommon,
  alsa-lib,
  at-spi2-core,
  gcc,
  nss,
  nspr,
  cups,
  libdrm,
  gtk3,
  pango,
  cairo,
  xorg,
  mesa,
  libglvnd,
  dbus,
  libpulseaudio,
  freetype,
  fontconfig,
  wayland,
  wayland-protocols,

}:

let
  electron = electron_33;
in
stdenv.mkDerivation rec {
  pname = "expresslrs-configurator";
  version = "1.7.2";

  src = fetchzip {
    url = "https://github.com/ExpressLRS/ExpressLRS-Configurator/releases/download/v${version}/expresslrs-configurator-${version}.zip";
    stripRoot = false;
    sha256 = "sha256-pXmJ420HeJaMjAZCzlIriuFrTK5xabxTrSy3PDVisgU=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    gcc
    libgcc
    libstdcxx5
    musl
    libxc
    libxkbcommon
    alsa-lib
    at-spi2-core
    gcc
    nss
    nspr
    cups
    libdrm
    gtk3
    pango
    cairo
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrandr
    mesa
    libglvnd
    dbus
    libpulseaudio
    freetype
    fontconfig
    wayland
    wayland-protocols
  ];

  installPhase = ''
     mkdir -p $out/bin $out/share/expresslrs-configurator/
     cp -r $src/{locales,resources}/* $out/share/expresslrs-configurator

    makeWrapper '${electron}/bin/electron' "$out/bin/expresslrs-configurator" \
     --add-flags "$out/share/expresslrs-configurator/app.asar" \
     --add-flags "--enable-logging --log-file=/tmp/electron-log.txt" \
     --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"
  '';

  meta = with lib; {
    description = "Cross-platform build & configuration tool for ExpressLRS";
    homepage = "https://github.com/ExpressLRS/ExpressLRS-Configurator";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ asamonik ];
  };
}
