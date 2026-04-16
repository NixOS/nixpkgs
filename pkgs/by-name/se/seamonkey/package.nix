{ lib, stdenv, fetchurl, gtk3, gtk2, gdk-pixbuf, dbus-glib, xorg, libpulseaudio, libGL, pango, freetype, fontconfig, autoPatchelfHook, makeWrapper, wrapGAppsHook3}:

stdenv.mkDerivation rec {
  pname = "seamonkey";
  version = "2.53.23";

  src = fetchurl {
    url = "https://archive.seamonkey-project.org/releases/${version}/linux-x86_64/en-US/seamonkey-${version}.en-US.linux-x86_64.tar.bz2";
    sha256 = "1si5vqprq7hgm366db76yziqxcqdvxj675kgxb6lp2ppprl8rlkw";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    gtk2
    gtk3
    gdk-pixbuf
    dbus-glib
    libpulseaudio
    libGL
    pango
    freetype
    fontconfig
    xorg.libXi
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXrender
    xorg.libXcomposite
    xorg.libXext
    xorg.libX11
    xorg.libXt
  ];

  installPhase = ''
    mkdir -p $out/lib/seamonkey $out/bin
    cp -r * $out/lib/seamonkey/

    ln -s $out/lib/seamonkey/seamonkey $out/bin/seamonkey

    wrapProgram $out/bin/seamonkey \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libpulseaudio libGL ]}"
  '';

  meta = with lib; {
    description = "The SeaMonkey project is a community effort to deliver production-quality releases of code names previously known as 'Mozilla Application Suite'";
    homepage = "https://www.seamonkey-project.org/";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "seamonkey";
  };
}