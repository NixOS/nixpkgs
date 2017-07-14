{ stdenv, fetchurl, writeText, makeWrapper
# Dependencies documented @ https://gnuradio.org/doc/doxygen/build_guide.html
# => core dependencies
, cmake, pkgconfig, git, boost, cppunit, fftw
# => python wrappers
# May be able to upgrade to swig3
, python, swig2, numpy, scipy, matplotlib
# => grc - the gnu radio companion
, cheetah, pygtk
# => gr-wavelet: collection of wavelet blocks
, gsl
# => gr-qtgui: the Qt-based GUI
, qt4, qwt, pyqt4
# => gr-wxgui: the Wx-based GUI
, wxPython, lxml
# => gr-audio: audio subsystems (system/OS dependent)
, alsaLib   # linux   'audio-alsa'
, CoreAudio # darwin  'audio-osx'
# => uhd: the Ettus USRP Hardware Driver Interface
, uhd
# => gr-video-sdl: PAL and NTSC display
, SDL
# Other
, libusb1, orc, pyopengl
}:

stdenv.mkDerivation rec {
  name = "gnuradio-${version}";
  version = "3.7.11";

  src = fetchurl {
    url = "https://gnuradio.org/releases/gnuradio/${name}.tar.gz";
    sha256 = "1m2jf8lafr6pr2dlm40nbvr6az8gwjfkzpbs4fxzv3l5hcqvmnc7";
  };

  nativeBuildInputs = [
    cmake pkgconfig git makeWrapper cppunit orc
  ];

  buildInputs = [
    boost fftw python swig2 lxml qt4
    qwt SDL libusb1 uhd gsl
  ] ++ stdenv.lib.optionals stdenv.isLinux  [ alsaLib   ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreAudio ];

  propagatedBuildInputs = [
    cheetah numpy scipy matplotlib pyqt4 pygtk wxPython pyopengl
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace \
        gr-fec/include/gnuradio/fec/polar_decoder_common.h \
        --replace BOOST_CONSTEXPR_OR_CONST const
  '';

  # Enables composition with nix-shell
  grcSetupHook = writeText "grcSetupHook.sh" ''
    addGRCBlocksPath() {
      addToSearchPath GRC_BLOCKS_PATH $1/share/gnuradio/grc/blocks
    }
    envHooks+=(addGRCBlocksPath)
  '';

  setupHook = [ grcSetupHook ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-unused-variable -std=c++11"
  '';

  # Framework path needed for qwt6_qt4 but not qwt5
  cmakeFlags =
    stdenv.lib.optionals stdenv.isDarwin [ "-DCMAKE_FRAMEWORK_PATH=${qwt}/lib" ];

  # - Ensure we get an interactive backend for matplotlib. If not the gr_plot_*
  #   programs will not display anything. Yes, $MATPLOTLIBRC must point to the
  #   *dirname* where matplotlibrc is located, not the file itself.
  # - GNU Radio core is C++ but the user interface (GUI and API) is Python, so
  #   we must wrap the stuff in bin/.
  # Notes:
  # - May want to use makeWrapper instead of wrapProgram
  # - may want to change interpreter path on Python examples instead of wrapping
  # - see https://github.com/NixOS/nixpkgs/issues/22688 regarding use of --prefix / python.withPackages
  # - see https://github.com/NixOS/nixpkgs/issues/24693 regarding use of DYLD_FRAMEWORK_PATH on Darwin
  postInstall = ''
    printf "backend : Qt4Agg\n" > "$out/share/gnuradio/matplotlibrc"

    for file in $(find $out/bin $out/share/gnuradio/examples -type f -executable); do
        wrapProgram "$file" \
            --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out") \
            --set MATPLOTLIBRC "$out/share/gnuradio" \
            ${stdenv.lib.optionalString stdenv.isDarwin "--set DYLD_FRAMEWORK_PATH /System/Library/Frameworks"}
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
    homepage = https://www.gnuradio.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
