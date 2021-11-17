{ fetchurl, lib, stdenv, autoPatchelfHook, dpkg, curl, libX11, libXext, squashfsTools
, xorg, makeWrapper, wrapGAppsHook, freetype, glib, pango
, atk, gdk-pixbuf, gtk3, cups, nss, libpng, libnotify, libgcrypt
, systemd, fontconfig, ffmpeg, dbus, at-spi2-atk
, at-spi2-core, mesa, libxkbcommon, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "polar";
    desktopName = "Polar";
    comment = "One-click Bitcoin Lightning networks for local app development & testing";
    genericName = "Polar";
    exec = "polar --no-sandbox";
    icon = "polar";
    startupNotify = "true";
    categories = "Utility;Development;";
  };
in
stdenv.mkDerivation rec {
  pname = "polar";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/jamaljsr/polar/releases/download/v${version}/${pname}-linux-amd64-v${version}.deb";
    hash = "sha256:0wq40qf33wmyfbf5xrlqjpamfgc71nrfdkq7yn4ai0vk0vpbjcj3";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [
    curl
  ] ++ runtimeDependencies;

  runtimeDependencies = map lib.getLib [
    atk
    dbus
    cups
    ffmpeg
    fontconfig
    freetype
    glib
    gtk3
    libgcrypt
    libnotify
    libpng
    libxkbcommon
    mesa
    nss
    pango
    stdenv.cc.cc
    systemd
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libxshmfence
    xorg.libXtst
  ];

  unpackCmd = "dpkg -x $curSrc source";

  installPhase = ''
    mv usr $out
    mv opt $out
    substituteInPlace $out/share/applications/${pname}.desktop --replace /usr/ $out/
  '';

  meta = with lib; {
    description = "One-click Bitcoin Lightning networks for local app development & testing";
    homepage = "https://lightningpolar.com";
    license = licenses.mit;
    maintainers = with maintainers; [ jamaljsr ];
    platforms = [ "x86_64-linux" ];
  };
}
