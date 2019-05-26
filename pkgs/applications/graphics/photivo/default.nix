{ stdenv, fetchhg, fetchpatch, cmake, qt4, fftw, graphicsmagick_q16,
  lcms2, lensfun, pkgconfig, libjpeg, exiv2, liblqr1 }:

stdenv.mkDerivation rec {
  name = "photivo-2014-01-25";

  src = fetchhg {
    url = "http://code.google.com/p/photivo/";
    rev = "d687864489da";
    sha256 = "0f6y18k7db2ci6xn664zcwm1g1k04sdv7gg1yd5jk41bndjb7z8h";
  };

  patches = [
    # Patch fixing build with lensfun >= 0.3, taken from
    # https://www.linuxquestions.org/questions/slackware-14/photivo-4175530230/#post5296578
    (fetchpatch {
      url = "https://www.linuxquestions.org/questions/attachment.php?attachmentid=17287&d=1420577220";
      name = "lensfun-0.3.patch";
      sha256 = "0ys45x4r4bjjlx0zpd5d56rgjz7k8gxili4r4k8zx3zfka4a3zwv";
    })
    ./gcc6.patch
  ];

  postPatch = '' # kinda icky
    sed -e '/("@INSTALL@")/d' \
        -e s,@INSTALL@,$out/share/photivo, \
        -i Sources/ptSettings.cpp
    sed '1i#include <math.h>' -i Sources/filters/ptFilter_StdCurve.cpp
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ qt4 fftw graphicsmagick_q16 lcms2 lensfun libjpeg exiv2 liblqr1 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
