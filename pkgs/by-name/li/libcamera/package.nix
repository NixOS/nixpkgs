{
  stdenv,
  fetchgit,
  lib,
  meson,
  ninja,
  pkg-config,
  makeFontsConf,
  openssl,
  libdrm,
  libevent,
  libyaml,
  gst_all_1,
  gtest,
  graphviz,
  doxygen,
  python3,
  python3Packages,
  udev,
  libpisp,
  withTracing ? lib.meta.availableOn stdenv.hostPlatform lttng-ust,
  lttng-ust, # withTracing
  withQcam ? false,
  qt6, # withQcam
  libtiff, # withQcam
}:

stdenv.mkDerivation rec {
  pname = "libcamera";
  version = "0.5.2";

  src = fetchgit {
    url = "https://git.libcamera.org/libcamera/libcamera.git";
    rev = "v${version}";
    hash = "sha256-nr1LmnedZMGBWLf2i5uw4E/OMeXObEKgjuO+PUx/GDY=";
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

    # yamlparser
    libyaml

    gtest
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch [ libpisp ]
  ++ lib.optionals withTracing [ lttng-ust ]
  ++ lib.optionals withQcam [
    libtiff
    qt6.qtbase
    qt6.qttools
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    python3Packages.jinja2
    python3Packages.pyyaml
    python3Packages.ply
    python3Packages.sphinx
    graphviz
    doxygen
    openssl
  ]
  ++ lib.optional withQcam qt6.wrapQtAppsHook;

  mesonFlags = [
    "-Dv4l2=true"
    (lib.mesonEnable "tracing" withTracing)
    (lib.mesonEnable "qcam" withQcam)
    "-Dlc-compliance=disabled" # tries unconditionally to download gtest when enabled
    # Avoid blanket -Werror to evade build failures on less
    # tested compilers.
    "-Dwerror=false"
    # Documentation breaks binary compatibility.
    # Given that upstream also provides public documentation,
    # we can disable it here.
    "-Ddocumentation=disabled"
  ];

  # Fixes error on a deprecated declaration
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  # Silence fontconfig warnings about missing config
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  meta = with lib; {
    description = "Open source camera stack and framework for Linux, Android, and ChromeOS";
    homepage = "https://libcamera.org";
    changelog = "https://git.libcamera.org/libcamera/libcamera.git/tag/?h=${src.rev}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ citadelcore ];
    platforms = platforms.linux;
    badPlatforms = [
      # Mandatory shared libraries.
      lib.systems.inspect.platformPatterns.isStatic
    ];
  };
}
