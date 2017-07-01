{ fetchurl, stdenv, dpkg, xorg, alsaLib, makeWrapper, openssl, freetype
, glib, pango, cairo, atk, gdk_pixbuf, gtk2, cups, nspr, nss, libpng, GConf
, libgcrypt, systemd, fontconfig, dbus, expat, ffmpeg_0_10, curl, zlib, gnome2 }:

assert stdenv.system == "x86_64-linux";

let
  # Please update the stable branch!
  # Latest version number can be found at:
  # http://repository-origin.spotify.com/pool/non-free/s/spotify-client/
  version = "1.0.57.474.gca9c9538-30";

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
    gtk2
    libgcrypt
    libpng
    nss
    pango
    stdenv.cc.cc
    systemd
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
    xorg.libxcb
    zlib
  ];

in

stdenv.mkDerivation {
  name = "spotify-${version}";

  src = fetchurl {
    url = "https://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_${version}_amd64.deb";
    sha256 = "fe46f2084c45c756bee366f744d2821d79e82866b19942e30bb2a20c1e597437";
  };

  buildInputs = [ dpkg makeWrapper ];

  doConfigure = false;
  doBuild = false;
  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase =
    ''
      runHook preInstall

      libdir=$out/lib/spotify
      mkdir -p $libdir
      mv ./usr/* $out/

      # Work around Spotify referring to a specific minor version of
      # OpenSSL.

      ln -s ${openssl.out}/lib/libssl.so $libdir/libssl.so.1.0.0
      ln -s ${openssl.out}/lib/libcrypto.so $libdir/libcrypto.so.1.0.0
      ln -s ${nspr.out}/lib/libnspr4.so $libdir/libnspr4.so
      ln -s ${nspr.out}/lib/libplc4.so $libdir/libplc4.so

      rpath="$out/share/spotify:$libdir"

      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/share/spotify/spotify

      librarypath="${stdenv.lib.makeLibraryPath deps}:$libdir"
      wrapProgram $out/share/spotify/spotify \
        --prefix LD_LIBRARY_PATH : "$librarypath" \
        --prefix PATH : "${gnome2.zenity}/bin"

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

      runHook postInstall
    '';

  meta = with stdenv.lib; {
    homepage = https://www.spotify.com/;
    description = "Play music from the Spotify music service";
    license = licenses.unfree;
    maintainers = with maintainers; [ eelco ftrvxmtrx sheenobu mudri ];
    platforms = [ "x86_64-linux" ];
  };
}
