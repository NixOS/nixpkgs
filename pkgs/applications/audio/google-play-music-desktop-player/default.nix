{ stdenv, alsaLib, atk, cairo, cups, dbus, dpkg, expat, fontconfig, freetype
, fetchurl, GConf, gdk_pixbuf, glib, gtk2, libpulseaudio, makeWrapper, nspr
, nss, pango, udev, xorg
}:

let
  version = "4.2.0";

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
    gtk2
    libpulseaudio
    nspr
    nss
    pango
    stdenv.cc.cc
    udev
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
    xorg.libXtst
  ];

in

stdenv.mkDerivation {
  name = "google-play-music-desktop-player-${version}";

  src = fetchurl {
    url = "https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v${version}/google-play-music-desktop-player_${version}_amd64.deb";
    sha256 = "0n59b73jc6b86p5063xz7n0z48wy9mzqcx0l34av2hqkx6wcb2h8";
  };

  dontBuild = true;
  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ./usr/share $out
    cp -r ./usr/bin $out

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             "$out/share/google-play-music-desktop-player/Google Play Music Desktop Player"

    wrapProgram $out/bin/google-play-music-desktop-player \
      --prefix LD_LIBRARY_PATH : "$out/share/google-play-music-desktop-player" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath deps}"
  '';

  meta = {
    homepage = https://www.googleplaymusicdesktopplayer.com/;
    description = "A beautiful cross platform Desktop Player for Google Play Music";
    license = stdenv.lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = stdenv.lib.maintainers.SuprDewd;
  };
}
