{stdenv, lib, libXcomposite, libgnome_keyring, makeWrapper, udev, curl, alsaLib
  ,libXfixes, atk, gtk2, libXrender, pango, gnome2, cairo, freetype, fontconfig
  ,libX11, libXi, libXext, libXcursor, glib, libXScrnSaver, libxkbfile, libXtst
  ,nss, nspr, cups, fetchurl, expat, gdk_pixbuf, libXdamage, libXrandr, dbus
}:

stdenv.mkDerivation rec {
  name = "gitkraken-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "https://release.gitkraken.com/linux/v${version}.tar.gz";
    sha256 = "56b5657f5c13fa1d8f6b7b9331194cbc8c48c0b913e5f0fb561d0e9af82f7999";
  };

  libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc.lib
    curl
    udev
    libX11
    libXext
    libXcursor
    libXi
    glib
    libXScrnSaver
    libxkbfile
    libXtst
    nss
    nspr
    cups
    alsaLib
    expat
    gdk_pixbuf
    dbus
    libXdamage
    libXrandr
    atk
    pango
    cairo
    freetype
    fontconfig
    libXcomposite
    libXfixes
    libXrender
    gtk2
    gnome2.GConf
    libgnome_keyring
  ];

  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/opt/gitkraken"
    cp -r ./* "$out/opt/gitkraken"
    fixupPhase
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
             --set-rpath "$libPath:$out/opt/gitkraken" "$out/opt/gitkraken/gitkraken"
    wrapProgram $out/opt/gitkraken/gitkraken \
      --prefix LD_PRELOAD : "${stdenv.lib.makeLibraryPath [ curl ]}/libcurl.so.4" \
      --prefix LD_PRELOAD : "${stdenv.lib.makeLibraryPath [ libgnome_keyring ]}/libgnome-keyring.so.0"
    mkdir "$out/bin"
    ln -s "$out/opt/gitkraken/gitkraken" "$out/bin/gitkraken"
  '';

  meta = with stdenv.lib; {
    homepage = https://www.gitkraken.com/;
    description = "The downright luxurious and most popular Git client for Windows, Mac & Linux";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
