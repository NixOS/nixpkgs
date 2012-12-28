{ stdenv, fetchurl, which, qt4, x11, pulseaudio, fftwSinglePrec
, lame, zlib, mesa, alsaLib, freetype, perl, pkgconfig
, libX11, libXv, libXrandr, libXvMC, libXinerama, libXxf86vm, libXmu
}:

stdenv.mkDerivation rec {
  name = "mythtv-0.24.2";

  src = fetchurl {
    url = "http://ftp.osuosl.org/pub/mythtv/${name}.tar.bz2";
    sha256 = "14mkyf2b26pc9spx6lg15mml0nqyg1r3qnq8m9dz3110h771y2db";
  };

  buildInputs = [
    freetype qt4 lame zlib x11 mesa perl alsaLib pulseaudio fftwSinglePrec
    libX11 libXv libXrandr libXvMC libXmu libXinerama libXxf86vm libXmu
  ];

  nativeBuildInputs = [ pkgconfig which ];

  patches = [ ./settings.patch ];
}
