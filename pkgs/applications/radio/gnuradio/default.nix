{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
# Remove gcc and python references
, removeReferencesTo
, pkgconfig
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
, alsaLib
, libjack2
, CoreAudio
, uhd
, SDL
, gsl
, cppzmq
, zeromq
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
  minor = "2";
  patch = "0";
}
# Should be false on the release after 3.8.2.0
, fetchSubmodules ? true
}:

let
  sourceSha256 =  "1mnfwdy7w3160vi6110x2qkyq8l78qi8771zwak9n72bl7lhhpnf";
  featuresInfo = {
    # Needed always
    basic = {
      native = [
        cmake
        pkgconfig
        orc
      ];
      runtime = [
        boost
        log4cpp
        mpir
      ];
      pythonNative = with python.pkgs; [
        Mako
        six
      ];
    };
    # NOTE: Should be removed on the release after 3.8.2.0, see:
    # https://github.com/gnuradio/gnuradio/commit/80c04479d
    volk = {
      cmakeEnableFlag = "VOLK";
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
      # Thrift support is not really working well, and even the patch they
      # recommend applying on 0.9.2 won't apply. See:
      # https://github.com/gnuradio/gnuradio/blob/v3.8.2.0/gnuradio-runtime/lib/controlport/thrift/README
      cmakeEnableFlag = "GR_CTRLPORT";
      native = [
        swig
      ];
    };
    gnuradio-companion = {
      pythonRuntime = with python.pkgs; [
        pyyaml
        Mako
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
        ++ stdenv.lib.optionals stdenv.isLinux [ alsaLib libjack2 ]
        ++ stdenv.lib.optionals stdenv.isDarwin [ CoreAudio ]
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
    };
    gr-modtool = {
      pythonRuntime = with python.pkgs; [
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
      runtime = [ cppzmq zeromq ];
      cmakeEnableFlag = "GR_ZEROMQ";
    };
  };
  shared = (import ./shared.nix {
    inherit
      stdenv
      python
      removeReferencesTo
      featuresInfo
      features
      versionAttr
      sourceSha256
      overrideSrc
      fetchFromGitHub
      fetchSubmodules
    ;
    qt = qt5;
    gtk = gtk3;
  });
  inherit (shared)
    version
    src
    hasFeature # function
    nativeBuildInputs
    buildInputs
    disallowedReferences
    stripDebugList
    passthru
    doCheck
    dontWrapPythonPrograms
    meta
  ;
  cmakeFlags = shared.cmakeFlags
    # From some reason, if these are not set, libcodec2 and gsm are not
    # detected properly. NOTE: qradiolink needs libcodec2 to be detected in
    # order to build, see https://github.com/qradiolink/qradiolink/issues/67
    ++ stdenv.lib.optionals (hasFeature "gr-vocoder" features) [
      "-DLIBCODEC2_LIBRARIES=${codec2}/lib/libcodec2.so"
      "-DLIBCODEC2_INCLUDE_DIRS=${codec2}/include"
      "-DLIBCODEC2_HAS_FREEDV_API=ON"
      "-DLIBGSM_LIBRARIES=${gsm}/lib/libgsm.so"
      "-DLIBGSM_INCLUDE_DIRS=${gsm}/include/gsm"
    ]
  ;

  postInstall = shared.postInstall
    # This is the only python reference worth removing, if needed (3.7 doesn't
    # set that reference).
    + stdenv.lib.optionalString (!hasFeature "python-support" features) ''
      ${removeReferencesTo}/bin/remove-references-to -t ${python} $out/lib/cmake/gnuradio/GnuradioConfig.cmake
    ''
  ;
  preConfigure = ''
  ''
    # If python-support is disabled, don't install volk's (git submodule)
    # volk_modtool - it references python.
    #
    # NOTE: on the next release, volk will always be required to be installed
    # externally (submodule removed upstream). Hence this hook will fail and
    # we'll need to package volk while able to tell it to install or not
    # install python referencing files. When we'll be there, this will help:
    # https://github.com/gnuradio/volk/pull/404
    + stdenv.lib.optionalString (!hasFeature "python-support" features) ''
      sed -i -e "/python\/volk_modtool/d" volk/CMakeLists.txt
    ''
  ;
  patches = [
    # Don't install python referencing files if python support is disabled.
    # See: https://github.com/gnuradio/gnuradio/pull/3839
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/4a4fd570b398b0b50fe875fcf0eb9c9db2ea5c6e.diff";
      sha256 = "xz2E0ji6zfdOAhjfPecAcaVOIls1XP8JngLkBbBBW5Q=";
    })
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/dbc8ad7e7361fddc7b1dbc267c07a776a3f9664b.diff";
      sha256 = "tQcCpcUbJv3yqAX8rSHN/pAuBq4ueEvoVo7sNzZGvf4=";
    })
  ];
in

stdenv.mkDerivation rec {
  inherit
    pname
    version
    src
    nativeBuildInputs
    buildInputs
    cmakeFlags
    preConfigure
    # disallowedReferences
    stripDebugList
    patches
    postInstall
    passthru
    doCheck
    dontWrapPythonPrograms
    meta
  ;
}
