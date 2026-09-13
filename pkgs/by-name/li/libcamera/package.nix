{
  stdenv,
  fetchFromGitLab,
  testers,
  nix-update-script,
  lib,
  meson,
  ninja,
  pkg-config,
  makeFontsConf,
  openssl,
  libdrm,
  libevent,
  libyaml,
  libyuv,
  gst_all_1,
  gtest,
  python3,
  python3Packages,
  udev,
  libpisp,
  libglvnd,
  enableDocumentation ? false,
  graphviz,
  doxygen,
  withTracing ? lib.meta.availableOn stdenv.hostPlatform lttng-ust,
  lttng-ust, # withTracing
  withSoftispGPU ? true, # software ISP GPU acceleration
  withQcam ? false, # cannot be enabled per default as it causes infinite recursion
  # withQcam
  qt6,
  libjpeg,
  libtiff,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcamera";
  version = "0.7.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "camera";
    repo = "libcamera";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vhFkeT1j2KKm+CVvGrtH5BEYJSEdaX7N7DRdA0a9EWk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    patchShebangs src/py/ utils/
  '';

  # libcamera signs the IPA module libraries at install time, but they are then
  # modified by stripping and RPATH fixup. Therefore, we need to generate the
  # signatures again ourselves. For reproducibility, we use a static private key.
  #
  # If this is not done, libcamera will still try to load them, but it will
  # isolate them in separate processes, which can cause crashes for IPA modules
  # that are not designed for this (notably ipa_rpi.so).
  preBuild = ''
    ninja src/ipa-priv-key.pem
    install -D ${./ipa-priv-key.pem} src/ipa-priv-key.pem
  '';

  postFixup = ''
    ../src/ipa/ipa-sign-install.sh src/ipa-priv-key.pem $out/lib/libcamera/ipa/ipa_*.so
  '';

  strictDeps = true;

  buildInputs = [
    # IPA and signing
    openssl

    # gstreamer integration
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base

    # cam integration
    libevent
    libdrm

    # hotplugging
    udev

    # pycamera
    python3Packages.pybind11

    libyuv

    # yamlparser
    libyaml

    gtest
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch [ libpisp ]
  ++ lib.optionals withTracing [ lttng-ust ]
  ++ lib.optionals withSoftispGPU [ libglvnd ]
  ++ lib.optionals withQcam [
    libjpeg
    libtiff
    qt6.qtbase
    qt6.qttools
    SDL2
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    python3Packages.jinja2
    python3Packages.pyyaml
    python3Packages.ply
    openssl
  ]
  ++ lib.optionals enableDocumentation [
    python3Packages.sphinx
    graphviz
    doxygen
  ]
  ++ lib.optional withQcam qt6.wrapQtAppsHook;

  mesonFlags =
    lib.mapAttrsToList lib.mesonEnable {
      v4l2 = true;
      tracing = true;
      pycamera = true;
      qcam = true;
      apps-output-dng = withQcam;
      cam-output-sdl2 = withQcam;
      cam-jpeg = withQcam;
      softisp-gpu = withSoftispGPU;
      libunwind = false;
      libdw = false;
      lc-compliance = true;

      # Documentation breaks binary compatibility.
      # Given that upstream also provides public documentation,
      # we can disable it here.
      documentation = enableDocumentation;

      rpi-awb-nn = false;
    }
    ++ [
      (lib.mesonBool "test" finalAttrs.finalPackage.doCheck)

      # Avoid blanket -Werror to evade build failures on less
      # tested compilers.
      (lib.mesonBool "werror" false)
    ];

  env = {
    # Fixes error on a deprecated declaration
    NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

    # Silence fontconfig warnings about missing config
    FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };
  };

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Open source camera stack and framework for Linux, Android, and ChromeOS";
    homepage = "https://libcamera.org";
    changelog = "https://git.libcamera.org/libcamera/libcamera.git/tag/?h=${finalAttrs.src.rev}";
    license = lib.licenses.lgpl2Plus;
    pkgConfigModules = [
      "libcamera"
      "libcamera-base"
    ];
    maintainers = with lib.maintainers; [
      citadelcore
      tmarkus
    ];
    platforms = lib.platforms.linux;
    badPlatforms = [
      # Mandatory shared libraries.
      lib.systems.inspect.platformPatterns.isStatic
    ];
  };
})
