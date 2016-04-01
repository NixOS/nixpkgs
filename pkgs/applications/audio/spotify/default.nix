{ fetchurl, stdenv, dpkg, xorg, alsaLib, makeWrapper, openssl_1_0_1, freetype
, glib, pango, cairo, atk, gdk_pixbuf, gtk, cups, nspr, nss, libpng, GConf
, libgcrypt, libudev, fontconfig, dbus, expat, ffmpeg_0_10, curl, zlib, gnome }:

assert stdenv.system == "x86_64-linux";

let
  version = "1.0.26.125.g64dc8bc6-14";

  deps = [
    alsaLib
    atk
    cairo
    cups
    curl
    dbus
    expat
    ffmpeg_0_10
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
    stdenv.cc.cc
    libudev
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    zlib
  ];

in

stdenv.mkDerivation {
  name = "spotify-${version}";

  src =
    fetchurl {
      url = "http://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_${version}_amd64.deb";
      sha256 = "09wanpml2a6k8asfc0pd56n7fia37amgsplsan1qdh6dwdzr3rv5";
    };

  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";

  installPhase =
    ''
      libdir=$out/lib/spotify
      mkdir -p $libdir
      dpkg-deb -x $src $out
      mv $out/usr/* $out/
      rm -rf $out/usr

      # Work around Spotify referring to a specific minor version of
      # OpenSSL.

      ln -s ${openssl_1_0_1.out}/lib/libssl.so $libdir/libssl.so.1.0.0
      ln -s ${openssl_1_0_1.out}/lib/libcrypto.so $libdir/libcrypto.so.1.0.0
      ln -s ${nspr.out}/lib/libnspr4.so $libdir/libnspr4.so
      ln -s ${nspr.out}/lib/libplc4.so $libdir/libplc4.so

      rpath="$out/share/spotify:$libdir"

      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/share/spotify/spotify

      librarypath="${stdenv.lib.makeLibraryPath deps}:$libdir"
      wrapProgram $out/share/spotify/spotify \
        --prefix LD_LIBRARY_PATH : "$librarypath" \
        --prefix PATH : "${gnome.zenity}/bin"

      # Desktop file
      mkdir -p "$out/share/applications/"
      cp "$out/share/spotify/spotify.desktop" "$out/share/applications/"

      # Icons
      for i in 16 22 24 32 48 64 128 256 512; do
        ixi="$i"x"$i"
        mkdir -p "$out/share/icons/hicolor/$ixi/apps"
        ln -s "$out/share/spotify/icons/spotify-linux-$i.png" \
          "$out/share/icons/hicolor/$ixi/apps/spotify-client.png"
      done
    '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = https://www.spotify.com/;
    description = "Play music from the Spotify music service";
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ eelco ftrvxmtrx ];
  };
}
