{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
# Remove gcc and python references
, removeReferencesTo
, pkg-config
, volk
, cppunit
, orc
, boost
, spdlog
, mpir
, doxygen
, python
, codec2
, gsm
, fftwFloat
, alsa-lib
, libjack2
, libiio
, libad9361
, CoreAudio
, uhd
, SDL
, gsl
, soapysdr
, libsodium
, libsndfile
, libunwind
, thrift
, cppzmq
, zeromq
# Needed only if qt-gui is disabled, from some reason
, icu
# GUI related
, gtk3
, pango
, gobject-introspection
, cairo
, qt5
, libsForQt5
# Features available to override, the list of them is in featuresInfo. They
# are all turned on by default.
, features ? {}
# If one wishes to use a different src or name for a very custom build
, overrideSrc ? {}
, pname ? "gnuradio"
, versionAttr ? {
  major = "3.10";
  minor = "1";
  patch = "0";
}
}:

let
  sourceSha256 = "sha256-bU6z7H08G8QIToogAMI2P5tHBtVZezlBDqSbnEsqAjE=";
  featuresInfo = {
    # Needed always
    basic = {
      native = [
        cmake
        pkg-config
        orc
      ];
      runtime = [
        volk
        boost
        spdlog
        mpir
      ]
        # when gr-qtgui is disabled, icu needs to be included, otherwise
        # building with boost 1.7x fails
        ++ lib.optionals (!(hasFeature "gr-qtgui")) [ icu ];
      pythonNative = with python.pkgs; [
        Mako
        six
      ];
    };
    doxygen = {
      native = [ doxygen ];
      cmakeEnableFlag = "DOXYGEN";
    };
    man-pages = {
      cmakeEnableFlag = "MANPAGES";
    };
    python-support = {
      pythonRuntime = [ python.pkgs.six ];
      native = [
        python
      ];
      cmakeEnableFlag = "PYTHON";
    };
    testing-support = {
      native = [ cppunit ];
      cmakeEnableFlag = "TESTING";
    };
    post-install = {
      cmakeEnableFlag = "POSTINSTALL";
    };
    gnuradio-runtime = {
      cmakeEnableFlag = "GNURADIO_RUNTIME";
      pythonRuntime = [
        python.pkgs.pybind11
      ];
    };
    gr-ctrlport = {
      runtime = [
        libunwind
        thrift
      ];
      pythonRuntime = with python.pkgs; [
        python.pkgs.thrift
        # For gr-perf-monitorx
        matplotlib
        networkx
      ];
      cmakeEnableFlag = "GR_CTRLPORT";
    };
    gnuradio-companion = {
      pythonRuntime = with python.pkgs; [
        pyyaml
        Mako
        numpy
        pygobject3
      ];
      native = [
        python.pkgs.pytest
      ];
      runtime = [
        gtk3
        pango
        gobject-introspection
        cairo
        libsndfile
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
      pythonRuntime = with python.pkgs; [
        scipy
        pyqtgraph
      ];
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
    gr-audio = {
      runtime = []
        ++ lib.optionals stdenv.isLinux [ alsa-lib libjack2 ]
        ++ lib.optionals stdenv.isDarwin [ CoreAudio ]
      ;
      cmakeEnableFlag = "GR_AUDIO";
    };
    gr-channels = {
      cmakeEnableFlag = "GR_CHANNELS";
    };
    gr-pdu = {
      cmakeEnableFlag = "GR_PDU";
      runtime = [
        libiio
        libad9361
      ];
    };
    gr-iio = {
      cmakeEnableFlag = "GR_IIO";
      runtime = [
        libiio
      ];
    };
    common-precompiled-headers = {
      cmakeEnableFlag = "COMMON_PCH";
    };
    gr-qtgui = {
      runtime = [ qt5.qtbase libsForQt5.qwt ];
      pythonRuntime = [ python.pkgs.pyqt5 ];
      cmakeEnableFlag = "GR_QTGUI";
    };
    gr-trellis = {
      cmakeEnableFlag = "GR_TRELLIS";
    };
    gr-uhd = {
      runtime = [
        uhd
      ];
      cmakeEnableFlag = "GR_UHD";
    };
    gr-uhd-rfnoc = {
      runtime = [
        uhd
      ];
      cmakeEnableFlag = "UHD_RFNOC";
    };
    gr-utils = {
      cmakeEnableFlag = "GR_UTILS";
      pythonRuntime = with python.pkgs; [
        # For gr_plot
        matplotlib
      ];
    };
    gr-modtool = {
      pythonRuntime = with python.pkgs; [
        setuptools
        click
        click-plugins
      ];
      cmakeEnableFlag = "GR_MODTOOL";
    };
    gr-blocktool = {
      cmakeEnableFlag = "GR_BLOCKTOOL";
    };
    gr-video-sdl = {
      runtime = [ SDL ];
      cmakeEnableFlag = "GR_VIDEO_SDL";
    };
    gr-vocoder = {
      runtime = [ codec2 gsm ];
      cmakeEnableFlag = "GR_VOCODER";
    };
    gr-wavelet = {
      cmakeEnableFlag = "GR_WAVELET";
      runtime = [ gsl libsodium ];
    };
    gr-zeromq = {
      runtime = [ cppzmq zeromq ];
      cmakeEnableFlag = "GR_ZEROMQ";
    };
    gr-network = {
      cmakeEnableFlag = "GR_NETWORK";
    };
    gr-soapy = {
      cmakeEnableFlag = "GR_SOAPY";
      runtime = [
        soapysdr
      ];
    };
  };
  shared = (import ./shared.nix {
    inherit
      stdenv
      lib
      python
      removeReferencesTo
      featuresInfo
      features
      versionAttr
      sourceSha256
      overrideSrc
      fetchFromGitHub
    ;
    qt = qt5;
    gtk = gtk3;
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
    cmakeFlags
    disallowedReferences
    stripDebugList
    doCheck
    dontWrapPythonPrograms
    dontWrapQtApps
    meta
  ;
  patches = [
    # Not accepted upstream, see https://github.com/gnuradio/gnuradio/pull/5227
    ./modtool-newmod-permissions.patch
  ];
  passthru = shared.passthru // {
    # Deps that are potentially overriden and are used inside GR plugins - the same version must
    inherit boost volk;
  } // lib.optionalAttrs (hasFeature "gr-uhd") {
    inherit uhd;
  } // lib.optionalAttrs (hasFeature "gr-qtgui") {
    inherit (libsForQt5) qwt;
  };

  postInstall = shared.postInstall
    # This is the only python reference worth removing, if needed.
    + lib.optionalString (!hasFeature "python-support") ''
      ${removeReferencesTo}/bin/remove-references-to -t ${python} $out/lib/cmake/gnuradio/GnuradioConfig.cmake
      ${removeReferencesTo}/bin/remove-references-to -t ${python} $(readlink -f $out/lib/libgnuradio-runtime.so)
      ${removeReferencesTo}/bin/remove-references-to -t ${python.pkgs.pybind11} $out/lib/cmake/gnuradio/gnuradio-runtimeTargets.cmake
    ''
  ;
}
