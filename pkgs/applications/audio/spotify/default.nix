{ fetchurl, stdenv, dpkg, xlibs, qt4, alsaLib, makeWrapper, openssl, freetype
, glib, pango, cairo, atk, gdk_pixbuf, gtk, cups, nspr, nss, libpng, GConf
, libgcrypt, chromium, udev, fontconfig
, dbus, expat }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let
  version = if stdenv.system == "i686-linux"
    then "0.9.4.183.g644e24e.428"
    else "0.9.11.27.g2b1a638.81";

  deps = [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    GConf
    gdk_pixbuf
    glib
    gtk
    libgcrypt
    libpng
    nss
    pango
    qt4
    stdenv.cc.gcc
    xlibs.libX11
    xlibs.libXcomposite
    xlibs.libXdamage
    xlibs.libXext
    xlibs.libXfixes
    xlibs.libXi
    xlibs.libXrandr
    xlibs.libXrender
    xlibs.libXrender
    xlibs.libXScrnSaver
  ];

in

stdenv.mkDerivation {
  name = "spotify-${version}";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client_${version}-1_i386.deb";
        sha256 = "1wl6v5x8vm74h5lxp8fhvmih8l122aadsf1qxvpk0k3y6mbx0ifa";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client_${version}-1_amd64.deb";
        sha256 = "0yfljiw01kssj3qaz8m0ppgrpjs6xrhzlr2wccp64bsnmin7g4sg";
      }
    else throw "Spotify not supported on this platform.";

  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";

  installPhase =
    ''
      libdir=$out/lib/spotify
      mkdir -p $libdir
      dpkg-deb -x $src $out
      mv $out/opt/spotify/* $out/
      rm -rf $out/usr $out/opt

      # Work around Spotify referring to a specific minor version of
      # OpenSSL.

      ln -s ${nss}/lib/libnss3.so $libdir/libnss3.so.1d
      ln -s ${nss}/lib/libnssutil3.so $libdir/libnssutil3.so.1d
      ln -s ${nss}/lib/libsmime3.so $libdir/libsmime3.so.1d

      ${if stdenv.system == "x86_64-linux" then ''
      ln -s ${openssl}/lib/libssl.so $libdir/libssl.so.1.0.0
      ln -s ${openssl}/lib/libcrypto.so $libdir/libcrypto.so.1.0.0
      ln -s ${nspr}/lib/libnspr4.so $libdir/libnspr4.so
      ln -s ${nspr}/lib/libplc4.so $libdir/libplc4.so
      '' else ''
      ln -s ${openssl}/lib/libssl.so $libdir/libssl.so.0.9.8
      ln -s ${openssl}/lib/libcrypto.so $libdir/libcrypto.so.0.9.8
      ln -s ${nspr}/lib/libnspr4.so $libdir/libnspr4.so.0d
      ln -s ${nspr}/lib/libplc4.so $libdir/libplc4.so.0d
      ''}

      # Work around Spotify trying to open libudev.so.0 (which we don't have)
      ln -s ${udev}/lib/libudev.so.1 $libdir/libudev.so.0

      mkdir -p $out/bin

      rpath="$out/spotify-client/Data:$libdir:$out/spotify-client:${stdenv.cc.gcc}/lib64"

      ln -s $out/spotify-client/spotify $out/bin/spotify

      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/spotify-client/spotify

      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/spotify-client/Data/SpotifyHelper

      preload=$out/libexec/spotify/libpreload.so
      librarypath="${stdenv.lib.makeLibraryPath deps}:$libdir"
      mkdir -p $out/libexec/spotify
      gcc -shared ${./preload.c} -o $preload -ldl -DOUT=\"$out\" -fPIC

      wrapProgram $out/bin/spotify --set LD_PRELOAD $preload --prefix LD_LIBRARY_PATH : "$librarypath"
      wrapProgram $out/spotify-client/Data/SpotifyHelper --set LD_PRELOAD $preload --prefix LD_LIBRARY_PATH : "$librarypath"

      # Desktop file
      mkdir -p "$out/share/applications/"
      cp "$out/spotify-client/spotify.desktop" "$out/share/applications/"
      sed -i "s|Icon=.*|Icon=$out/spotify-client/Icons/spotify-linux-512.png|" "$out/share/applications/spotify.desktop"
    ''; # */

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = https://www.spotify.com/;
    description = "Play music from the Spotify music service";
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
