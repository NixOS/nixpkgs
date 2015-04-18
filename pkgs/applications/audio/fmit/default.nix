{ stdenv, fetchurl, alsaLib, cmake, fftw, freeglut, jack2, libXmu, qt4 }:

stdenv.mkDerivation rec {
  version = "0.99.5";
  name = "fmit-${version}";

  src = fetchurl {
    url = "http://download.gna.org/fmit/${name}-Source.tar.bz2";
    sha256 = "1rc84gi27jmq2smhk0y0p2xyypmsz878vi053iqns21k848g1491";
  };

  # Also update longDescription when adding/removing sound libraries
  buildInputs = [ alsaLib cmake fftw freeglut jack2 libXmu qt4 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free Musical Instrument Tuner";
    longDescription = ''
      Software for tuning musical instruments. Uses Qt as GUI library and
      ALSA or JACK as sound input library.
    '';
    homepage = http://home.gna.org/fmit/index.html;
    license = with licenses; gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
