{stdenv, fetchurl, qt4, qmake4Hook, exiv2, openexr, fftwSinglePrec, libtiff, ilmbase }:

stdenv.mkDerivation rec {
  name = "qtpfsgui-1.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/qtpfsgui/${name}.tar.gz";
    sha256 = "1mlg9dry4mfnnjlnwsw375hzsiagssdhccfmapx5nh6ykqrslsh1";
  };

  buildInputs = [ qt4 exiv2 openexr fftwSinglePrec libtiff ];
  nativeBuildInputs = [ qmake4Hook ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    export CPATH="${ilmbase.dev}/include/OpenEXR:$CPATH"
  '';

  qmakeFlags = [
    "EXIV2PATH=${exiv2.dev}/include/exiv2"
    "OPENEXRDIR=${openexr.dev}/include/OpenEXR"
    "FFTW3DIR=${fftwSinglePrec.dev}/include"
    "LIBTIFFDIR=${libtiff.dev}/include"
  ];

  meta = {
    homepage = http://qtpfsgui.sourceforge.net/;
    description = "Qtpfsqui, a graphical application for high dynamic range (HDR) imaging";

    longDescription =
      '' Qtpfsgui is an open source graphical user interface application that
         aims to provide a workflow for high dynamic range (HDR) imaging.
      '';

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
