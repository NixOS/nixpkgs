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
, thrift
, fftwFloat
, alsa-lib
, libjack2
, CoreAudio
, uhd
, SDL
, gsl
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
, versionAttr ? {
  major = "3.8";
  minor = "5";
  patch = "0";
}
}:

let
  sourceSha256 = "sha256-p4VFjTE0GXmdA7QGhWSUzO/WxJ+8Dq3JEnOABtQtJUU=";
  featuresInfo = {
    # Needed always
    basic = {
      native = [
        cmake
        pkg-config
        orc
      ];
      runtime = [
        boost
        log4cpp
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
      runtime = [
        thrift
      ];
      pythonRuntime = with python.pkgs; [
        python.pkgs.thrift
        # For gr-perf-monitorx
        matplotlib
        networkx
      ];
    };
    gnuradio-companion = {
      pythonRuntime = with python.pkgs; [
        pyyaml
        mako
        numpy
        pygobject3
      ];
      runtime = [
        gtk3
        pango
        gobject-introspection
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
    gr-qtgui = {
      runtime = [ qt5.qtbase libsForQt5.qwt ];
      pythonRuntime = [ python.pkgs.pyqt5 ];
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
      runtime = [ gsl ];
    };
    gr-zeromq = {
      runtime = [ cppzmq ];
      cmakeEnableFlag = "GR_ZEROMQ";
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

stdenv.mkDerivation {
  inherit pname;
  inherit (shared)
    version
    src
    nativeBuildInputs
    buildInputs
    disallowedReferences
    stripDebugList
    doCheck
    dontWrapPythonPrograms
    dontWrapQtApps
    meta
  ;
  patches = [
    # Not accepted upstream, see https://github.com/gnuradio/gnuradio/pull/5227
    ./modtool-newmod-permissions.3_8.patch
    # Fix compilation with boost 177
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/2c767bb260a25b415e8c9c4b3ea37280b2127cec.patch";
      sha256 = "sha256-l4dSzkXb5s3vcCeuKMMwiKfv83hFI9Yg+EMEX+sl+Uo=";
    })
  ];
  passthru = shared.passthru // {
    # Deps that are potentially overridden and are used inside GR plugins - the same version must
    inherit
      boost
      volk
    ;
    # Used by many gnuradio modules, the same attribute is present in
    # gnuradio3.10 where there it's spdlog.
    logLib = log4cpp;
  } // lib.optionalAttrs (hasFeature "gr-uhd") {
    inherit uhd;
  } // lib.optionalAttrs (hasFeature "gr-qtgui") {
    inherit (libsForQt5) qwt;
  };
  cmakeFlags = shared.cmakeFlags
    # From some reason, if these are not set, libcodec2 and gsm are not
    # detected properly. The issue is reported upstream:
    # https://github.com/gnuradio/gnuradio/issues/4278
    # The above issue was fixed for GR3.9 without a backporting patch.
    #
    # NOTE: qradiolink needs libcodec2 to be detected in
    # order to build, see https://github.com/qradiolink/qradiolink/issues/67
    ++ lib.optionals (hasFeature "gr-vocoder") [
      "-DLIBCODEC2_FOUND=TRUE"
      "-DLIBCODEC2_LIBRARIES=${codec2}/lib/libcodec2${stdenv.hostPlatform.extensions.sharedLibrary}"
      "-DLIBCODEC2_INCLUDE_DIRS=${codec2}/include"
      "-DLIBCODEC2_HAS_FREEDV_API=ON"
      "-DLIBGSM_FOUND=TRUE"
      "-DLIBGSM_LIBRARIES=${gsm}/lib/libgsm${stdenv.hostPlatform.extensions.sharedLibrary}"
      "-DLIBGSM_INCLUDE_DIRS=${gsm}/include/gsm"
    ]
    ++ lib.optionals (hasFeature "volk" && volk != null) [
      "-DENABLE_INTERNAL_VOLK=OFF"
    ]
  ;

  postInstall = shared.postInstall
    # This is the only python reference worth removing, if needed (3.7 doesn't
    # set that reference).
    + lib.optionalString (!hasFeature "python-support") ''
      ${removeReferencesTo}/bin/remove-references-to -t ${python} $out/lib/cmake/gnuradio/GnuradioConfig.cmake
    ''
  ;
}
