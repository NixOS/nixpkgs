{ fetchurl, stdenv, dpkg, xlibs, qt4, alsaLib, makeWrapper, openssl, freetype
, glib, pango, cairo, atk, gdk_pixbuf, gtk, cups, nspr, nss, libpng, GConf
, libgcrypt, chromium, sqlite, gst_plugins_base, gstreamer, udev, fontconfig
, dbus, expat }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let
  version = if stdenv.system == "i686-linux"
    then "0.9.4.183.g644e24e.428"
    else "0.9.10.17.g4129e1c.78";

  qt4webkit =
    if stdenv.system == "i686-linux" then
      fetchurl {
        name = "libqtwebkit4_2.3.2_i386.deb";
        url = http://ie.archive.ubuntu.com/ubuntu/pool/main/q/qtwebkit-source/libqtwebkit4_2.3.2-0ubuntu7_i386.deb;
        sha256 = "0hi6cwx2b2cwa4nv5phqqw526lc8p9x7kjkcza9x47ny3npw2924";
      }
    else
      fetchurl {
        name = "libqtwebkit4_2.3.2_amd64.deb";
        url = http://ie.archive.ubuntu.com/ubuntu/pool/main/q/qtwebkit-source/libqtwebkit4_2.3.2-0ubuntu7_amd64.deb;
        sha256 = "0sac88avfivwkfhmd6fik7ili8fdznqas6741dbspf9mfnawbwch";
      };

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
    gst_plugins_base
    gstreamer
    gtk
    libgcrypt
    libpng
    nss
    pango
    qt4
    sqlite
    stdenv.gcc.gcc
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
    #xlibs.libXss
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
        sha256 = "1a4vn2ij3nghnc0fq3nsyb95gwhaw4zabdq6jd52hxz8iv31pn1z";
      }
    else throw "Spotify not supported on this platform.";

  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";

  installPhase =
    ''
      mkdir -p $out
      dpkg-deb -x $src $out
      mv $out/opt/spotify/* $out/
      rm -rf $out/usr $out/opt

      # Work around Spotify referring to a specific minor version of
      # OpenSSL.
      mkdir $out/lib

      ln -s ${nss}/lib/libnss3.so $out/lib/libnss3.so.1d
      ln -s ${nss}/lib/libnssutil3.so $out/lib/libnssutil3.so.1d
      ln -s ${nss}/lib/libsmime3.so $out/lib/libsmime3.so.1d

      ${if stdenv.system == "x86_64-linux" then ''
      ln -s ${openssl}/lib/libssl.so $out/lib/libssl.so.1.0.0
      ln -s ${openssl}/lib/libcrypto.so $out/lib/libcrypto.so.1.0.0
      ln -s ${nspr}/lib/libnspr4.so $out/lib/libnspr4.so
      ln -s ${nspr}/lib/libplc4.so $out/lib/libplc4.so
      '' else ''
      ln -s ${openssl}/lib/libssl.so $out/lib/libssl.so.0.9.8
      ln -s ${openssl}/lib/libcrypto.so $out/lib/libcrypto.so.0.9.8
      ln -s ${nspr}/lib/libnspr4.so $out/lib/libnspr4.so.0d
      ln -s ${nspr}/lib/libplc4.so $out/lib/libplc4.so.0d
      ''}

      # Work around Spotify trying to open libudev.so.0 (which we don't have)
      ln -s ${udev}/lib/libudev.so.1 $out/lib/libudev.so.0

      mkdir -p $out/bin

      rpath="$out/spotify-client/Data:$out/lib:$out/spotify-client:${stdenv.gcc.gcc}/lib64"

      ln -s $out/spotify-client/spotify $out/bin/spotify

      patchelf \
        --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/spotify-client/spotify

      patchelf \
        --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/spotify-client/Data/SpotifyHelper

      dpkg-deb -x ${qt4webkit} ./
      mkdir -p $out/lib/
      cp -v usr/lib/*/* $out/lib/

      preload=$out/libexec/spotify/libpreload.so
      librarypath="${stdenv.lib.makeLibraryPath deps}:$out/lib"
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
    description = "Spotify for Linux allows you to play music from the Spotify music service";
    license = "unfree";
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
