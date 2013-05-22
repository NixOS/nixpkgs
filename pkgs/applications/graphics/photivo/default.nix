{ stdenv, fetchhg, cmake, qt4, fftw, graphicsmagick_q16,
  lcms2, lensfun, pkgconfig, libjpeg, exiv2, liblqr1 }:

stdenv.mkDerivation rec {
  name = "photivo-2013-05-20";

  src = fetchhg {
    url = "http://code.google.com/p/photivo/";
    tag = "6256ff175312";
    sha256 = "0pyvkijr7wwik21hdp1zwbbyqnhc07kf0m48ih1rws78fq3h86cc";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ qt4 fftw graphicsmagick_q16 lcms2 lensfun libjpeg exiv2 liblqr1 ];
}
