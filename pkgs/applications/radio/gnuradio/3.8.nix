{ stdenv
, fetchFromGitHub
# Dependencies documented @ https://www.gnuradio.org/doc/doxygen-v3.8.1.0/build_guide.html
# => core dependencies
, cmake
, pkgconfig
, orc # optional dependency for volk submodule
# boost 1.7 should work as well
, boost
, cppunit
, log4cpp
, mpir
# May be able to upgrade to swig3
, swig
, enableDoxygen ? false # docs
, doxygen
, python3
, enablePython ? true
, enableSphinx ? false # docs
, enableRuntime ? true # needed for most features
, enableCtrlport ? true
, enableBlocks ? true
, enableCompanion ? true
, gtk3 ? null
, cairo ? null
, pango ? null
, gobject-introspection ? null
# The following 3 usually go along together
, enableFec ? true
, enableFft ? true
, enableFilter ? true
, fftwFloat ? null
, enableAnalog ? true # needed for many other features
, enableDigital ? true
, enableDtv ? true
, enableAudio ? true
, alsaLib ? null
, libjack2 ? null
, CoreAudio ? null # audio
, enableChannels ? true
, enableQtgui ? true
, qt5 ? null
, qwt6 ? null
, enableTrellis ? true
, enableUhd ? true
, uhd ? null
, enableUtils ? true # requires enablePython = true;
, enableModtool ? true # requires enablePython = true;
, enableVideoSdl ? true
, SDL ? null
, enableVocoder ? true
, enableWavelet ? true
, gsl ? null
, enableZeromq ? true
, cppzmq ? null # This is just for zmq.hpp - cpp compatibility headers
, zeromq ? null
}:

let
  inherit (stdenv.lib) optionals;
  onOffBool = b: if b then "ON" else "OFF";
  pythonEnvInputs = with python3.pkgs; [
    Mako
    six
  ]
    ++ optionals (enableSphinx) [ sphinx ]
    ++ optionals (enableCompanion) [ pyyaml numpy pygobject3 ]
    ++ optionals (enableQtgui) [ pyqt5 ]
    ++ optionals (enableModtool) [ click click-plugins ]
  ;
in

stdenv.mkDerivation rec {
  pname = "gnuradio";
  version = "3.8.1.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = "gnuradio";
    rev = "v${version}";
    sha256 = "1pza788md9kawf714pbg9kwrqza8zqdn6b83r31v0mknq57ypmqn";
    fetchSubmodules = true;
  };

  pythonEnv = python3.withPackages(ps: pythonEnvInputs );
  passthru = {
    inherit pythonEnvInputs;
    inherit pythonEnv;
    # not sure if this is the best name for this property - but it's here to
    # signal plugins that they are compiling against 3.8
    branch = "3.8";
  };


  nativeBuildInputs = [
    cmake
    pkgconfig
    cppunit
    swig
    orc
  ]
    ++ optionals (enableDoxygen) [ doxygen ]
    # Python is still needed as a build time dep even if python-support is not installed
    ++ optionals (!enablePython && !enableQtgui) [ pythonEnv ]
  ;

  buildInputs = [
    boost
    log4cpp # for volk
    mpir
  ]
    ++ optionals (enableFft || enableFilter) [ fftwFloat ]
    ++ optionals (enableCompanion) [ gtk3 gobject-introspection pango cairo ]
    ++ optionals (enablePython || enableQtgui) [ pythonEnv ]
    ++ optionals (enableZeromq) [ cppzmq zeromq ]
    ++ optionals (enableVideoSdl) [ SDL ]
    ++ optionals (enableUhd) [ uhd ]
    ++ optionals (enableWavelet) [ gsl ]
    # we add libjack2 here unconditionally but support for it can be disabled with:
    # gnuradio3_7.override { libjack2 = null; }
    ++ optionals (enableAudio && stdenv.isLinux) [ alsaLib libjack2 ] 
    ++ optionals (enableAudio && stdenv.isDarwin) [ CoreAudio ]
    ++ optionals (enableQtgui) [ qt5.qtbase qwt6 ]
  ;

  enableParallelBuilding = true;

  # checks fail due to error: `libgnuradio-runtime-..so: cannot open shared object file`
  doCheck = false;

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
    "-DENABLE_GR_AUDIO=${onOffBool enableAudio}"
    "-DENABLE_GR_CHANNELS=${onOffBool enableChannels}"
    "-DENABLE_GR_QTGUI=${onOffBool enableQtgui}"
    "-DENABLE_GR_TRELLIS=${onOffBool enableTrellis}"
    "-DENABLE_GR_UHD=${onOffBool enableUhd}"
    "-DENABLE_GR_UTILS=${onOffBool enableUtils}"
    "-DENABLE_GR_MODTOOL=${onOffBool enableModtool}"
    "-DENABLE_GR_VIDEO_SDL=${onOffBool enableVideoSdl}"
    "-DENABLE_GR_VOCODER=${onOffBool enableVocoder}"
    "-DENABLE_GR_WAVELET=${onOffBool enableWavelet}"
    "-DENABLE_GR_ZEROMQ=${onOffBool enableZeromq}"
  ]
    # TODO: Check if needed
    # optionals stdenv.isDarwin [ "-DCMAKE_FRAMEWORK_PATH=${qwt6}/lib" ];
  ;

  # patching is done at the wrapper
  dontPatchShebangs = true;

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
