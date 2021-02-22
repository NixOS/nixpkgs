{ lib, stdenv, alsaLib, atk, at-spi2-atk, cairo, cups, dbus, dpkg, expat, fontconfig, freetype
, fetchurl, GConf, gdk-pixbuf, glib, gtk2, gtk3, libpulseaudio, makeWrapper, nspr
, nss, pango, udev, xorg
}:

let
  version = "4.7.1";

  deps = [
    alsaLib
    atk
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    GConf
    gdk-pixbuf
    glib
    gtk2
    gtk3
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
  pname = "google-play-music-desktop-player";
  inherit version;

  src = fetchurl {
    url = "https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v${version}/google-play-music-desktop-player_${version}_amd64.deb";
    sha256 = "1ljm9c5sv6wa7pa483yq03wq9j1h1jdh8363z5m2imz407yzgm5r";
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
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath deps}"
  '';

  meta = {
    homepage = "https://www.googleplaymusicdesktopplayer.com/";
    description = "A beautiful cross platform Desktop Player for Google Play Music";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.SuprDewd ];
  };
}
