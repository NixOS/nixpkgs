{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  # Remove gcc and python references
  removeReferencesTo,
  pkg-config,
  volk,
  cppunit,
  ctestCheckHook,
  orc,
  boost,
  spdlog,
  mpir,
  doxygen,
  python,
  codec2,
  gsm,
  fftwFloat,
  alsa-lib,
  libjack2,
  libiio,
  libad9361,
  uhd,
  SDL,
  gsl,
  soapysdr,
  libsndfile,
  libunwind,
  thrift,
  cppzmq,
  # GUI related
  gtk3,
  pango,
  gobject-introspection,
  cairo,
  qt5,
  libsForQt5,
  # Features available to override, the list of them is in featuresInfo. They
  # are all turned on by default.
  features ? { },
}:

let
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
      ];
      pythonNative = with python.pythonOnBuildForHost.pkgs; [
        mako
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
      pythonRuntime = [
        python.pkgs.thrift
        # For gr-perf-monitorx
        python.pkgs.matplotlib
        python.pkgs.networkx
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
        pyqt5
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
      runtime = lib.optionals stdenv.hostPlatform.isLinux [
        alsa-lib
        libjack2
      ];
      cmakeEnableFlag = "GR_AUDIO";
    };
    gr-channels = {
      cmakeEnableFlag = "GR_CHANNELS";
    };
    gr-pdu = {
      cmakeEnableFlag = "GR_PDU";
    };
    gr-iio = {
      cmakeEnableFlag = "GR_IIO";
      runtime = [
        libiio
        libad9361
      ];
    };
    common-precompiled-headers = {
      cmakeEnableFlag = "COMMON_PCH";
    };
    gr-qtgui = {
      runtime = [
        qt5.qtbase
        libsForQt5.qwt
      ];
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
        click
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
      runtime = [
        codec2
        gsm
      ];
      cmakeEnableFlag = "GR_VOCODER";
    };
    gr-wavelet = {
      cmakeEnableFlag = "GR_WAVELET";
      runtime = [
        gsl
      ];
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
  hasFeature = feat: features.${feat} or true;
  enabledFeatures = lib.attrValues (lib.filterAttrs (feat: _: hasFeature feat) featuresInfo);
  cross = stdenv.hostPlatform != stdenv.buildPlatform;
  libgnuradioRuntime = "$(readlink -f $out/lib/libgnuradio-runtime${stdenv.hostPlatform.extensions.sharedLibrary})";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "gnuradio";
  version = "3.10.12.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = "gnuradio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-489Pc6z6Ha7jkTzZSEArDQJGkWdWRDIn1uhfFyLLiCo=";
  };

  patches = [
    # Not accepted upstream, see https://github.com/gnuradio/gnuradio/pull/5227
    ./modtool-newmod-permissions.patch

    # Finding `boost_system` fails because the stub compiled library of
    # Boost.System, which has been a header-only library since 1.69, was
    # removed in 1.89.
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/d8814e0c3ef68372e5a1093603ef602e2119cd8a.patch";
      hash = "sha256-TQxqsce1AhSjdwaG2IP11QTeOgdJHN6cAAnznBl8eM8=";
    })
    # Needed for the patch below to be able to apply
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/56d230fd33fa2e8d6dc3685c9545589f21a6a1fd.patch";
      hash = "sha256-N6Y7B1EJKQxWlpu3E7sjNgivva8+x0V2DlBQMXYLXbA=";
    })
    # Fixes a test failing due to precision. See:
    # https://github.com/gnuradio/gnuradio/pull/8181
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/aee9fd3f79389c4282a98e8d62c8405c73fd91df.patch";
      hash = "sha256-UtYAJqqmydGs2EP4JOTGrQ6OgvL/jwGVwlhG4xxj8SU=";
    })
  ];

  nativeBuildInputs = [
    removeReferencesTo
  ]
  ++ lib.concatMap (info: info.native or [ ] ++ info.pythonNative or [ ]) enabledFeatures;
  buildInputs = lib.concatMap (
    info: info.runtime or [ ] ++ lib.optionals (hasFeature "python-support") (info.pythonRuntime or [ ])
  ) enabledFeatures;
  cmakeFlags = [
    # https://pybind11.readthedocs.io/en/stable/changelog.html#version-2-13-0-june-25-2024
    (lib.cmakeBool "CMAKE_CROSSCOMPILING" cross)
    (lib.cmakeBool "PYBIND11_USE_CROSSCOMPILING" (cross && hasFeature "gnuradio-runtime"))
  ]
  ++ lib.mapAttrsToList (
    feat: info:
    (
      if feat == "basic" then
        # Abuse this unavoidable "iteration" to set this flag which we want as
        # well - it means: Don't turn on features just because their deps are
        # satisfied, let only our cmakeFlags decide.
        (lib.cmakeBool "ENABLE_DEFAULT" false)
      else
        (lib.cmakeBool "ENABLE_${info.cmakeEnableFlag}" (hasFeature feat))
    )
  ) featuresInfo;

  # Wrapping is done with an external wrapper
  dontWrapPythonPrograms = true;
  dontWrapQtApps = true;

  postInstall =
    # Gcc references
    lib.optionalString (hasFeature "gnuradio-runtime") ''
      remove-references-to -t ${stdenv.cc} ${libgnuradioRuntime}
    ''
    # Clang references in InstalledDir
    + lib.optionalString (hasFeature "gnuradio-runtime" && stdenv.hostPlatform.isDarwin) ''
      remove-references-to -t ${stdenv.cc.cc} ${libgnuradioRuntime}
    ''
    # This is the only python reference worth removing, if needed.
    + lib.optionalString (!hasFeature "python-support") ''
      remove-references-to -t ${python} $out/lib/cmake/gnuradio/GnuradioConfig.cmake
    ''
    + lib.optionalString (!hasFeature "python-support" && hasFeature "gnuradio-runtime") ''
      remove-references-to -t ${python} ${libgnuradioRuntime}
      remove-references-to -t ${python.pkgs.pybind11} $out/lib/cmake/gnuradio/gnuradio-runtimeTargets.cmake
    '';
  disallowedReferences = [
    stdenv.cc
    stdenv.cc.cc
  ]
  # If python-support is disabled, we probably don't want it referenced
  ++ lib.optionals (!hasFeature "python-support") [ python ];
  # Gcc references from examples
  stripDebugList = [
    "lib"
    "bin"
  ]
  ++ lib.optionals (hasFeature "gr-audio") [ "share/gnuradio/examples/audio" ]
  ++ lib.optionals (hasFeature "gr-uhd") [ "share/gnuradio/examples/uhd" ]
  ++ lib.optionals (hasFeature "gr-qtgui") [ "share/gnuradio/examples/qt-gui" ];

  # NOTE: Other outputs are disabled due to upstream not using GNU InstallDIrs
  # cmake  module. It's not that bad since it's a development package for most
  # purposes. If closure size needs to be reduced, features should be disabled
  # via an override.
  outputs = [
    "out"
  ]
  ++ lib.optionals (hasFeature "man-pages") [
    "man"
  ];

  # On darwin, it requires playing with DYLD_FALLBACK_LIBRARY_PATH to make if
  # find libgnuradio-runtim.3.*.dylib .
  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [
    # To allow easier future test manipulations
    ctestCheckHook
  ];
  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_QPA_PLATFORM=offscreen
  ''
  + lib.optionalString (hasFeature "gr-qtgui") ''
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
  '';

  passthru = {
    # Deps that are potentially overridden and are used inside GR plugins - the same version must
    inherit
      uhd
      boost
      volk
      libiio
      libad9361
      python
      ;
    # Used by many gnuradio modules, the same attribute is present in
    # previous gnuradio versions where there it's log4cpp.
    logLib = spdlog;
    inherit (libsForQt5) qwt;
    # Inherit functions and Nix attribute sets
    inherit
      hasFeature
      featuresInfo
      ;
    versionAttr = {
      major = lib.versions.majorMinor finalAttrs.version;
      minor = lib.versions.patch finalAttrs.version;
      patch = lib.elemAt (lib.splitVersion finalAttrs.version) 3;
    };
    gnuradioOlder = lib.versionOlder finalAttrs.passthru.versionAttr.major;
    gnuradioAtLeast = lib.versionAtLeast finalAttrs.passthru.versionAttr.major;
  }
  // lib.optionalAttrs (hasFeature "gr-qtgui") {
    qt = qt5;
  }
  // lib.optionalAttrs (hasFeature "gnuradio-companion") {
    gtk = gtk3;
  };

  meta = {
    description = "Software Defined Radio (SDR) software";
    mainProgram = "gnuradio-config-info";
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
    changelog = "https://github.com/gnuradio/gnuradio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      doronbehar
      bjornfor
      fpletz
      jiegec
    ];
  };
})
