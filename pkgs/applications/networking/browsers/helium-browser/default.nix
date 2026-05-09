{ lib, stdenv, fetchurl, appimageTools, makeWrapper
, gtk3, libdrm, libxshmfence, mesa, nspr, nss, libGL, xorg
, alsa-lib, at-spi2-atk, atk, cairo, cups, dbus, expat, fontconfig
, freetype, gdk-pixbuf, glib, gnome2, libnotify, libX11, libXcomposite
, libXcursor, libXdamage, libXext, libXfixes, libXi, libXrandr
, libXrender, libXScrnSaver, libXtst, pango, systemd, udev, xdg-utils
, autoPatchelfHook }:

let
  pname = "helium-browser";
  version = "0.11.3.2";
  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-5gdyKg12ZV2hpf0RL+eoJnawuW/J8NobiG+zEA0IOHA=";
};
in appimageTools.wrapType2 rec {
  inherit pname version src;
  extraPkgs = pkgs: with pkgs; [
    gtk3 libdrm libxshmfence mesa nspr nss
    alsa-lib at-spi2-atk atk cairo cups dbus expat
    fontconfig freetype gdk-pixbuf glib gnome2.GConf
    libnotify libX11 libXcomposite libXcursor libXdamage
    libXext libXfixes libXi libXrandr libXrender libXScrnSaver
    libXtst pango systemd udev xdg-utils
  ];

  # Extract desktop item
  desktopItem = appimageTools.extractDesktopItem {
    inherit pname version;
    src = src;
    name = "${pname}";
    exec = "${placeholder "out"}/bin/${pname}";
    comment = meta.description;
    desktopName = lib.strings.capitalize pname;
    genericName = "Web Browser";
    categories = [ "Network" "WebBrowser" ];
    mimeTypes = [ "text/html" "text/xml" "application/xhtml+xml" "application/vnd.mozilla.xul+xml" ];
  };

  meta = with lib; {
    description = "Private, fast, and honest web browser based on Chromium";
    homepage = "https://helium.computer";
    license = licenses.gpl3;
    maintainers =  with maintainers; [ nilsritter ];
    platforms = platforms.linux;
    mainProgram = pname;
  };
}

