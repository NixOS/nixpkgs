{ stdenv, fetchurl
# core dependencies
, cmake, pkgconfig, git, boost, cppunit, fftw
# python wrappers
, python, swig2, numpy, scipy, matplotlib
# grc - the gnu radio companion
, cheetahTemplate, pygtk
# gr-wavelet: collection of wavelet blocks
, gsl
# gr-qtgui: the Qt-based GUI
, qt4, qwt, pyqt4 #, pyqwt
# gr-wxgui: the Wx-based GUI
, wxPython, lxml
# gr-audio: audio subsystems (system/OS dependent)
, alsaLib
# uhd: the Ettus USRP Hardware Driver Interface
, uhd
# gr-video-sdl: PAL and NTSC display
, SDL
, libusb1, orc, pyopengl
, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "gnuradio-${version}";
  version = "3.7.9.2";

  src = fetchurl {
    url = "http://gnuradio.org/releases/gnuradio/${name}.tar.gz";
    sha256 = "0qdmakvgq3jxnnqpcn3k4q07vj8ycrbyzv32h76k71cv13w2yrki";
  };

  buildInputs = [
    cmake pkgconfig git boost cppunit fftw python swig2 orc lxml qt4
    qwt alsaLib SDL libusb1 uhd gsl makeWrapper
  ];

  propagatedBuildInputs = [
    cheetahTemplate numpy scipy matplotlib pyqt4 pygtk wxPython pyopengl
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-unused-variable"
  '';

  # - Ensure we get an interactive backend for matplotlib. If not the gr_plot_*
  #   programs will not display anything. Yes, $MATPLOTLIBRC must point to the
  #   *dirname* where matplotlibrc is located, not the file itself.
  # - GNU Radio core is C++ but the user interface (GUI and API) is Python, so
  #   we must wrap the stuff in bin/.
  postInstall = ''
    printf "backend : Qt4Agg\n" > "$out/share/gnuradio/matplotlibrc"

    for file in "$out"/bin/* "$out"/share/gnuradio/examples/*/*.py; do
        wrapProgram "$file" \
            --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out") \
            --set MATPLOTLIBRC "$out/share/gnuradio"
    done
  '';

  meta = with stdenv.lib; {
    description = "Software Defined Radio (SDR) software";
    longDescription = ''
      GNU Radio is a free & open-source software development toolkit that
      provides signal processing blocks to implement software radios. It can be
      used with readily-available low-cost external RF hardware to create
      software-defined radios, or without hardware in a simulation-like
      environment. It is widely used in hobbyist, academic and commercial
      environments to support both wireless communications research and
      real-world radio systems.
    '';
    homepage = http://www.gnuradio.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
