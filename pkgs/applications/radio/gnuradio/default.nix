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
, version ? "3.10.7.0"
}:

let
  sourceSha256 = "sha256-7fIQMcx90wI4mAZmR26/rkBKPKhNxgu3oWpJTV3C+Ek=";
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
        mako
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
        mako
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
    jsonyaml_blocks = {
      pythonRuntime = [
        python.pkgs.jsonschema
      ];
      cmakeEnableFlag = "JSONYAML_BLOCKS";
    };
    gr-blocks = {
      cmakeEnableFlag = "GR_BLOCKS";
      runtime = [
        # Required to compile wavfile blocks.
        libsndfile
      ];
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
        pygccxml
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
      runtime = [ cppzmq ];
      cmakeEnableFlag = "GR_ZEROMQ";
      pythonRuntime = [
        # Will compile without this, but it is required by tests, and by some
        # gr blocks.
        python.pkgs.pyzmq
      ];
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
      version
      sourceSha256
      overrideSrc
      fetchFromGitHub
    ;
    qt = qt5;
    gtk = gtk3;
  });
  inherit (shared.passthru) hasFeature; # function
in

stdenv.mkDerivation (finalAttrs: (shared // {
  inherit pname version;
  # Will still evaluate correctly if not used here. It only helps nix-update
  # find the right file in which version is defined.
  inherit (shared) src;
  patches = [
    # Not accepted upstream, see https://github.com/gnuradio/gnuradio/pull/5227
    ./modtool-newmod-permissions.patch
    # https://github.com/gnuradio/gnuradio/pull/6808
    (fetchpatch {
      name = "gnuradio-fmt10.1.patch";
      url = "https://github.com/gnuradio/gnuradio/commit/9357c17721a27cc0aae3fe809af140c84e492f37.patch";
      hash = "sha256-w3b22PTqoORyYQ3RKRG+2htQWbITzQiOdSDyuejUtHQ=";
    })
  ];
  passthru = shared.passthru // {
    # Deps that are potentially overridden and are used inside GR plugins - the same version must
    inherit
      boost
      volk
    ;
    # Used by many gnuradio modules, the same attribute is present in
    # previous gnuradio versions where there it's log4cpp.
    logLib = spdlog;
  } // lib.optionalAttrs (hasFeature "gr-uhd") {
    inherit uhd;
  } // lib.optionalAttrs (hasFeature "gr-pdu") {
    inherit libiio libad9361;
  } // lib.optionalAttrs (hasFeature "gr-qtgui") {
    inherit (libsForQt5) qwt;
  };

  postInstall = shared.postInstall
    # This is the only python reference worth removing, if needed.
    + lib.optionalString (!hasFeature "python-support") ''
      ${removeReferencesTo}/bin/remove-references-to -t ${python} $out/lib/cmake/gnuradio/GnuradioConfig.cmake
      ${removeReferencesTo}/bin/remove-references-to -t ${python} $(readlink -f $out/lib/libgnuradio-runtime${stdenv.hostPlatform.extensions.sharedLibrary})
      ${removeReferencesTo}/bin/remove-references-to -t ${python.pkgs.pybind11} $out/lib/cmake/gnuradio/gnuradio-runtimeTargets.cmake
    ''
  ;
}))
