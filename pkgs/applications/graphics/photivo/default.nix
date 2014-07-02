{ stdenv, fetchhg, cmake, qt4, fftw, graphicsmagick_q16,
  lcms2, lensfun, pkgconfig, libjpeg, exiv2, liblqr1 }:

stdenv.mkDerivation rec {
  name = "photivo-2014-01-25";

  src = fetchhg {
    url = "http://code.google.com/p/photivo/";
    rev = "d687864489da";
    sha256 = "0f6y18k7db2ci6xn664zcwm1g1k04sdv7gg1yd5jk41bndjb7z8h";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ qt4 fftw graphicsmagick_q16 lcms2 lensfun libjpeg exiv2 liblqr1 ];
  patchPhase = '' # kinda icky
    sed -e '/("@INSTALL@")/d' \
        -e s,@INSTALL@,$out/share/photivo, \
        -i Sources/ptSettings.cpp
  '';

  meta = with stdenv.lib; {
      platforms = platforms.linux;
      maintainers = maintainers.mornfall;
  };
}
