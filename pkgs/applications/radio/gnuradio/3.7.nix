{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
# Remove gcc and python references
, removeReferencesTo
, pkg-config
, volk
, cppunit
, swig
, orc
, boost
, log4cpp
, mpir
, doxygen
, python
, codec2
, gsm
, fftwFloat
, alsa-lib
, libjack2
, CoreAudio
, uhd
, comedilib
, libusb1
, SDL
, gsl
, cppzmq
, zeromq
# GUI related
, gtk2
, pango
, cairo
, qt4
, qwt6_qt4
# Features available to override, the list of them is in featuresInfo. They
# are all turned on by default
, features ? {}
# If one wishes to use a different src or name for a very custom build
, overrideSrc ? {}
, pname ? "gnuradio"
, versionAttr ? {
  major = "3.7";
  minor = "14";
  patch = "0";
}
}:

let
  sourceSha256 = "BiUDibXV/5cEYmAAaIxT4WTxF/ni4MJumF5oJ/vuOyc=";
  featuresInfo = {
    # Needed always
    basic = {
      native = [
        cmake
        pkg-config
        orc
      ];
      runtime = [ boost log4cpp mpir ];
      pythonNative = with python.pkgs; [ Mako six ];
    };
    volk = {
      cmakeEnableFlag = "VOLK";
      runtime = [
        volk
      ];
    };
    doxygen = {
      native = [ doxygen ];
      cmakeEnableFlag = "DOXYGEN";
    };
    sphinx = {
      pythonNative = with python.pkgs; [ sphinx ];
      cmakeEnableFlag = "SPHINX";
    };
    python-support = {
      pythonRuntime = [ python.pkgs.six ];
      native = [
        swig
        python
      ];
      cmakeEnableFlag = "PYTHON";
    };
    testing-support = {
      native = [ cppunit ];
      cmakeEnableFlag = "TESTING";
    };
    gnuradio-runtime = {
      cmakeEnableFlag = "GNURADIO_RUNTIME";
    };
    gr-ctrlport = {
      cmakeEnableFlag = "GR_CTRLPORT";
      native = [
        swig
      ];
    };
    gnuradio-companion = {
      pythonRuntime = with python.pkgs; [
        pyyaml
        cheetah
        lxml
        pygtk
        numpy
        # propagated by pygtk, but since wrapping is done externally, it help
        # the wrapper if it's here
        pycairo
        pygobject2
      ];
      runtime = [
        gtk2
        pango
        cairo
      ];
      cmakeEnableFlag = "GRC";
    };
    gr-blocks = {
      cmakeEnableFlag = "GR_BLOCKS";
    };
    gr-fec = {
      cmakeEnableFlag = "GR_FEC";
    };
    gr-fft = {
      runtime = [ fftwFloat ];
      cmakeEnableFlag = "GR_FFT";
    };
    gr-filter = {
      runtime = [ fftwFloat ];
      cmakeEnableFlag = "GR_FILTER";
    };
    gr-analog = {
      cmakeEnableFlag = "GR_ANALOG";
    };
    gr-digital = {
      cmakeEnableFlag = "GR_DIGITAL";
    };
    gr-dtv = {
      cmakeEnableFlag = "GR_DTV";
    };
    gr-atsc = {
      cmakeEnableFlag = "GR_ATSC";
    };
    gr-audio = {
      runtime = []
        ++ lib.optionals stdenv.isLinux [ alsa-lib libjack2 ]
        ++ lib.optionals stdenv.isDarwin [ CoreAudio ]
      ;
      cmakeEnableFlag = "GR_AUDIO";
    };
    gr-comedi = {
      runtime = [ comedilib ];
      cmakeEnableFlag = "GR_COMEDI";
    };
    gr-channels = {
      cmakeEnableFlag = "GR_CHANNELS";
    };
    gr-noaa = {
      cmakeEnableFlag = "GR_NOAA";
    };
    gr-pager = {
      cmakeEnableFlag = "GR_PAGER";
    };
    gr-qtgui = {
      runtime = [ qt4 qwt6_qt4 ];
      pythonRuntime = [ python.pkgs.pyqt4 ];
      cmakeEnableFlag = "GR_QTGUI";
    };
    gr-trellis = {
      cmakeEnableFlag = "GR_TRELLIS";
    };
    gr-uhd = {
      runtime = [ uhd ];
      cmakeEnableFlag = "GR_UHD";
    };
    gr-utils = {
      cmakeEnableFlag = "GR_UTILS";
    };
    gr-video-sdl = {
      runtime = [ SDL ];
      cmakeEnableFlag = "GR_VIDEO_SDL";
    };
    gr-vocoder = {
      runtime = [ codec2 gsm ];
      cmakeEnableFlag = "GR_VOCODER";
    };
    gr-fcd = {
      runtime = [ libusb1 ];
      cmakeEnableFlag = "GR_FCD";
    };
    gr-wavelet = {
      cmakeEnableFlag = "GR_WAVELET";
      runtime = [ gsl ];
    };
    gr-zeromq = {
      runtime = [ cppzmq zeromq ];
      cmakeEnableFlag = "GR_ZEROMQ";
    };
    gr-wxgui = {
      pythonRuntime = with python.pkgs; [ numpy wxPython ];
      cmakeEnableFlag = "GR_WXGUI";
    };
  };
  shared = (import ./shared.nix {
    inherit
      lib
      stdenv
      python
      removeReferencesTo
      featuresInfo
      features
      versionAttr
      sourceSha256
      overrideSrc
      fetchFromGitHub
    ;
    qt = qt4;
    gtk = gtk2;
  });
  inherit (shared) hasFeature; # function
in

stdenv.mkDerivation rec {
  inherit pname;
  inherit (shared)
    version
    src
    nativeBuildInputs
    buildInputs
    disallowedReferences
    postInstall
    doCheck
    dontWrapPythonPrograms
    meta
  ;

  passthru = shared.passthru // {
    # Deps that are potentially overriden and are used inside GR plugins - the same version must
    inherit boost volk;
  } // lib.optionalAttrs (hasFeature "gr-uhd") {
    inherit uhd;
  };
  cmakeFlags = shared.cmakeFlags
    # From some reason, if these are not set, libcodec2 and gsm are
    # not detected properly (slightly different then what's in
    # ./default.nix).
    ++ lib.optionals (hasFeature "gr-vocoder") [
      "-DLIBCODEC2_LIBRARIES=${codec2}/lib/libcodec2.so"
      "-DLIBCODEC2_INCLUDE_DIR=${codec2}/include"
      "-DLIBGSM_LIBRARIES=${gsm}/lib/libgsm.so"
      "-DLIBGSM_INCLUDE_DIR=${gsm}/include/gsm"
    ]
    ++ lib.optionals (hasFeature "volk" && volk != null) [
      "-DENABLE_INTERNAL_VOLK=OFF"
    ]
  ;
  stripDebugList = shared.stripDebugList
    # gr-fcd feature was dropped in 3.8
    ++ lib.optionals (hasFeature "gr-fcd") [ "share/gnuradio/examples/fcd" ]
  ;
  preConfigure = ""
    # wxgui and pygtk are not looked up properly, so we force them to be
    # detected as found, if they are requested by the `features` attrset.
    + lib.optionalString (hasFeature "gr-wxgui") ''
      sed -i 's/.*wx\.version.*/set(WX_FOUND TRUE)/g' gr-wxgui/CMakeLists.txt
    ''
    + lib.optionalString (hasFeature "gnuradio-companion") ''
      sed -i 's/.*pygtk_version.*/set(PYGTK_FOUND TRUE)/g' grc/CMakeLists.txt
    ''
  ;
  patches = [
    # Don't install python referencing files if python support is disabled.
    # See: https://github.com/gnuradio/gnuradio/pull/3856
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/acef55433d15c231661fa44751f9a2d90a4baa4b.diff";
      sha256 = "2CEX44Ll8frfLXTIWjdDhKl7aXcjiAWsezVdwrynelE=";
    })
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/a2681edcfaabcb1ecf878ae861161b6a6bf8459d.diff";
      sha256 = "2Pitgu8accs16B5X5+/q51hr+IY9DMsA15f56gAtBs8=";
    })
  ];
}
