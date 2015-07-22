{ fetchurl, stdenv, dpkg, xlibs, qt4, alsaLib, makeWrapper, openssl, freetype
, glib, pango, cairo, atk, gdk_pixbuf, gtk, cups, nspr, nss, libpng, GConf
, libgcrypt, chromium, udev, fontconfig
, dbus, expat }:

assert stdenv.system == "x86_64-linux";

let
  version = "0.9.17.1.g9b85d43.7";

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
    stdenv.cc.cc
    udev
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
    fetchurl {
      url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client_${version}-1_amd64.deb";
      sha256 = "0x87q7gd2997sgppsm4lmdiz1cm11x5vnd5c34nqb5d4ry5qfyki";
    };

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

      ln -s ${openssl}/lib/libssl.so $libdir/libssl.so.1.0.0
      ln -s ${openssl}/lib/libcrypto.so $libdir/libcrypto.so.1.0.0
      ln -s ${nspr}/lib/libnspr4.so $libdir/libnspr4.so
      ln -s ${nspr}/lib/libplc4.so $libdir/libplc4.so

      mkdir -p $out/bin

      rpath="$out/spotify-client/Data:$libdir:$out/spotify-client:${stdenv.cc.cc}/lib64"

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
    maintainers = with stdenv.lib.maintainers; [ eelco ftrvxmtrx ];
  };
}
