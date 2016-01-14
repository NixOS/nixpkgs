{ fetchurl, stdenv, dpkg, xorg, alsaLib, makeWrapper, openssl_1_0_1, freetype
, glib, pango, cairo, atk, gdk_pixbuf, gtk, cups, nspr, nss, libpng, GConf
, libgcrypt, udev, fontconfig, dbus, expat, ffmpeg_0_10, curl, zlib, gnome }:

assert stdenv.system == "x86_64-linux";

let
  version = "1.0.19.106.gb8a7150f";

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
    udev
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
      sha256 = "be6b99329bb2fccdc9d77bc949dd463576fdb40db7f56195b4284bd348c470be";
    };

  buildInputs = [ dpkg makeWrapper ];

  propagatedUserEnvPkgs = [ gnome.zenity ];  # for adding local folders

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

      ln -s ${openssl_1_0_1}/lib/libssl.so $libdir/libssl.so.1.0.0
      ln -s ${openssl_1_0_1}/lib/libcrypto.so $libdir/libcrypto.so.1.0.0
      ln -s ${nspr}/lib/libnspr4.so $libdir/libnspr4.so
      ln -s ${nspr}/lib/libplc4.so $libdir/libplc4.so

      rpath="$out/share/spotify:$libdir"

      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/share/spotify/spotify

      librarypath="${stdenv.lib.makeLibraryPath deps}:$libdir"
      wrapProgram $out/share/spotify/spotify --prefix LD_LIBRARY_PATH : "$librarypath"

      # Desktop file
      mkdir -p "$out/share/applications/"
      cp "$out/share/spotify/spotify.desktop" "$out/share/applications/"
      sed -i "s|Icon=.*|Icon=$out/share/spotify/Icons/spotify-linux-512.png|" "$out/share/applications/spotify.desktop"
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
