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

  postPatch = ''
    substituteInPlace \
        gr-fec/include/gnuradio/fec/polar_decoder_common.h \
        --replace BOOST_CONSTEXPR_OR_CONST const
  '';

  setupHook = ./setup-hook.sh;

  # patch wxgui and pygtk check due to python importerror in a headless environment
  # wxgtk gui will be removed in GR3.8
  # c++11 hack may not be necessary anymore
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-unused-variable ${stdenv.lib.optionalString (!stdenv.isDarwin) "-std=c++11"}"
    sed -i 's/.*wx\.version.*/set(WX_FOUND TRUE)/g' gr-wxgui/CMakeLists.txt
    sed -i 's/.*pygtk_version.*/set(PYGTK_FOUND TRUE)/g' grc/CMakeLists.txt
    find . -name "CMakeLists.txt" -exec sed -i '1iadd_compile_options($<$<COMPILE_LANGUAGE:CXX>:-std=c++11>)' "{}" ";"
  '';

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
    homepage = "https://www.gnuradio.org";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
