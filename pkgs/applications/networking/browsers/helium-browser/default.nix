nix
{ lib
, stdenv
, appimageTools
, fetchurl
, makeWrapper
, gtk3
, libGL
, libxkbcommon
, xorg
, nss
, nspr
, atk
, at-spi2-atk
, cups
, dbus
, libdrm
, libxshmfence
, mesa
, pango
, cairo
, gdk-pixbuf
, glib
, alsa-lib
, expat
, fontconfig
, freetype
}:

appimageTools.wrapType2 {
  pname = "helium-browser";
  version = "0.7.1.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/0.7.1.1/helium-0.7.1.1-x86_64.AppImage";
    hash = "sha256-spUogmjv+RNjtuDs5tY7vXFgKR62qUb85Gj/bERCza4=";
  };

  extraPkgs = pkgs: with pkgs; [
    gtk3
    libGL
    libxkbcommon
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXrender
    xorg.libxcb
    xorg.libXcursor
    xorg.libXi
    xorg.libXScrnSaver
    nss
    nspr
    atk
    at-spi2-atk
    cups
    dbus
    libdrm
    libxshmfence
    mesa
    pango
    cairo
    gdk-pixbuf
    glib
    alsa-lib
    expat
    fontconfig
    freetype
  ];

  meta = with lib; {
    description = "Internet without interruptions - A privacy-focused browser";
    homepage = "https://github.com/imputnet/helium-linux";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ sharifmdathar ];
  };
}