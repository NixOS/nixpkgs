{stdenv, fetchurl, qt4, exiv2, openexr, fftw, libtiff, ilmbase }:

stdenv.mkDerivation rec {
  name = "qtpfsgui-1.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/qtpfsgui/${name}.tar.gz";
    sha256 = "1mlg9dry4mfnnjlnwsw375hzsiagssdhccfmapx5nh6ykqrslsh1";
  };

  buildInputs = [ qt4 exiv2 openexr fftw libtiff ];

  configurePhase = ''
    export CPATH="${ilmbase}/include/OpenEXR:$CPATH"
    qmake PREFIX=$out EXIV2PATH=${exiv2}/include/exiv2  \
      OPENEXRDIR=${openexr}/include/OpenEXR             \
      FFTW3DIR=${fftw}/include                          \
      LIBTIFFDIR=${libtiff}/include
  '';

  meta = {
    homepage = http://qtpfsgui.sourceforge.net/;
    description = "Qtpfsqui, a graphical application for high dynamic range (HDR) imaging";

    longDescription =
      '' Qtpfsgui is an open source graphical user interface application that
         aims to provide a workflow for high dynamic range (HDR) imaging.
      '';

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
