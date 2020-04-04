{ stdenv
, fetchFromGitHub
, makeWrapper
, writeText
# Dependencies documented @ https://www.gnuradio.org/doc/doxygen-3.7/build_guide.html
# => core dependencies
, cmake
, pkgconfig
, orc # optional dependency for volk submodule
# boost 1.7 should work as well
, boost
, cppunit
# May be able to upgrade to swig3
, swig
, enableDoxygen ? false # docs
, doxygen
, python2
, enablePython ? true
, enableSphinx ? false # docs
, enableRuntime ? true # needed for most features
, enableCtrlport ? true
, enableBlocks ? true
, enableCompanion ? true
# The following 3 usually go along together
, enableFec ? true
, enableFft ? true
, enableFilter ? true
, fftw ? null
, enableAnalog ? true # needed for many other features
, enableDigital ? true
, enableDtv ? true
, enableAtsc ? true
, enableAudio ? true # needed for fcd
, alsaLib ? null
, libjack2 ? null
, CoreAudio ? null # audio
# TODO: package https://github.com/Linux-Comedi/comedilib
, enableComedi ? false
, enableChannels ? true
, enableNoaa ? true
, enablePager ? true
, enableQtgui ? true
, qt4 ? null
, qwt ? null
, enableTrellis ? true
, enableUhd ? true
, uhd ? null
, enableUtils ? true # requires enablePython = true;
, enableVideoSdl ? true
, SDL ? null
, enableVocoder ? true
, enableFcd ? true
, libusb1 ? null
, enableWavelet ? true
, gsl ? null
, enableWxgui ? true
, enableZeromq ? true
, zeromq ? null
}:

let
  inherit (stdenv.lib) optionals;
  onOffBool = b: if b then "ON" else "OFF";
in

stdenv.mkDerivation rec {
  pname = "gnuradio";
  version = "3.7.14.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = "gnuradio";
    rev = "v${version}";
    sha256 = "1nh4f9dmygprlbqybd3j1byg9fsr6065n140mvc4b0v8qqygmhrc";
    fetchSubmodules = true;
  };

  pythonEnv = python2.withPackages(ps: with ps; [
    Mako
    six
  ]
    ++ optionals (enableSphinx) [ sphinx ]
    ++ optionals (enableCompanion) [ lxml pygtk numpy cheetah ]
    ++ optionals (enableQtgui) [ pyqt4 ]
    ++ optionals (enableWxgui) [ wxPython ]
  );

  nativeBuildInputs = [
    cmake
    pkgconfig
    cppunit
    swig
    orc
  ]
    ++ optionals (enableDoxygen) [ doxygen ]
    # Python is still needed as a build time dep even if python-support is not installed
    ++ optionals (!enablePython && !enableWxgui && !enableQtgui) [ pythonEnv ]
  ;

  buildInputs = [
    boost
  ]
    ++ optionals (enableFft || enableFilter) [ fftw ]
    ++ optionals (enablePython || enableWxgui || enableQtgui) [ pythonEnv ]
    ++ optionals (enableZeromq) [ zeromq ]
    ++ optionals (enableVideoSdl) [ SDL ]
    ++ optionals (enableUhd) [ uhd ]
    ++ optionals (enableWavelet) [ gsl ]
    ++ optionals (enableFcd) [ libusb1 ]
    # we add libjack2 here unconditionally but support for it can be disabled with:
    # gnuradio3_7.override { libjack2 = null; }
    ++ optionals (enableAudio && stdenv.isLinux) [ alsaLib libjack2 ] 
    ++ optionals (enableAudio && stdenv.isDarwin) [ CoreAudio ]
    ++ optionals (enableQtgui) [ qt4 qwt ]
    # ++ optionals (enableComedi) [ comedilib ] # not yet packaged, see TODO at top
  ;

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  # Framework path needed for qwt6_qt4 but not qwt5
  cmakeFlags = [
    "-DENABLE_PYTHON=${onOffBool enablePython}"
    "-DENABLE_GNURADIO_RUNTIME=${onOffBool enableRuntime}"
    "-DENABLE_GR_CTRLPORT=${onOffBool enableCtrlport}"
    "-DENABLE_GR_BLOCKS=${onOffBool enableBlocks}"
    "-DENABLE_GRC=${onOffBool enableCompanion}"
    "-DENABLE_GR_FEC=${onOffBool enableFec}"
    "-DENABLE_GR_FFT=${onOffBool enableFft}"
    "-DENABLE_GR_FILTER=${onOffBool enableFilter}"
    "-DENABLE_GR_ANALOG=${onOffBool enableAnalog}"
    "-DENABLE_GR_DIGITAL=${onOffBool enableDigital}"
    "-DENABLE_GR_ATSC=${onOffBool enableAtsc}"
    "-DENABLE_GR_AUDIO=${onOffBool enableAudio}"
    "-DENABLE_GR_COMEDI=${onOffBool enableComedi}"
    "-DENABLE_GR_CHANNELS=${onOffBool enableChannels}"
    "-DENABLE_GR_NOAA=${onOffBool enableNoaa}"
    "-DENABLE_GR_PAGER=${onOffBool enablePager}"
    "-DENABLE_GR_QTGUI=${onOffBool enableQtgui}"
    "-DENABLE_GR_TRELLIS=${onOffBool enableTrellis}"
    "-DENABLE_GR_UHD=${onOffBool enableUhd}"
    "-DENABLE_GR_UTILS=${onOffBool enableUtils}"
    "-DENABLE_GR_VIDEO_SDL=${onOffBool enableVideoSdl}"
    "-DENABLE_GR_VOCODER=${onOffBool enableVocoder}"
    "-DENABLE_GR_FCD=${onOffBool enableFcd}"
    "-DENABLE_GR_WAVELET=${onOffBool enableWavelet}"
    "-DENABLE_GR_WXGUI=${onOffBool enableWxgui}"
    "-DENABLE_GR_ZEROMQ=${onOffBool enableZeromq}"
  ]
    # From some reason, zeromq is not detected without this
    ++ optionals (enableZeromq) [ "-DZEROMQ_INCLUDE_DIRS=${zeromq}/include" ]
    # TODO: Check if needed
    # optionals stdenv.isDarwin [ "-DCMAKE_FRAMEWORK_PATH=${qwt}/lib" ];
  ;

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
    homepage = "https://www.gnuradio.org";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
