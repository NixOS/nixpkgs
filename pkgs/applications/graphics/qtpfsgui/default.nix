{stdenv, fetchurl, qt4, exiv2, openexr, fftw, libtiff, ilmbase }:

stdenv.mkDerivation {
  name = "qtpfsgui-1.9.2";

  src = fetchurl {
    url = mirror://sourceforge/qtpfsgui/qtpfsgui-1.9.2.tar.gz;
    sha256 = "13kcw760136zpg3b5qhd1sw3kqplicvlsqmy3rxxn5ygm0zfqqj4";
  };

  buildInputs = [ qt4 exiv2 openexr fftw libtiff ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  configurePhase = ''
    qmake PREFIX=$out EXIV2PATH=${exiv2}/include/exiv2 \
      OPENEXRDIR=${openexr}/include/OpenEXR \
      FFTW3DIR=${fftw}/include \
      LIBTIFFDIR=${libtiff}/include \
  '';

  meta = {
    homepage = http://qtpfsgui.sourceforge.net/;
    description = "GUI frontend for some pfstools";
    license = "GPL";
  };
}
