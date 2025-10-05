{
  stdenv,
  fetchurl,
  lib,
  cmake,
  extra-cmake-modules,
  pkg-config,
  kdePackages,
  fftw,
  curl,
  ffmpeg,
  gdk-pixbuf,
  gst_all_1,
  libaio,
  libmtp,
  libsysprof-capture,
  libunwind,
  loudmouth,
  lzo,
  lz4,
  mariadb-embedded,
  snappy,
  taglib,
  taglib_extras,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amarok";
  version = "3.3.1";

  src = fetchurl {
    url = "mirror://kde/stable/amarok/${finalAttrs.version}/amarok-${finalAttrs.version}.tar.xz";
    hash = "sha256-OW8uqToH25XI+762gNeAai5ZVKUgxSwFZIXBHeYznAE=";
  };

  outputs = [
    "out"
    "doc"
  ];

  buildInputs = [
    curl
    fftw
    ffmpeg
    gdk-pixbuf
    libaio
    libmtp
    libsysprof-capture
    libunwind
    loudmouth
    lz4
    lzo
    mariadb-embedded
    snappy
    taglib
    taglib_extras
  ]
  ++ (with kdePackages; [
    qca
    qt5compat
    qtbase
    qtdeclarative
    qtwebengine
    kcmutils
    kcoreaddons
    kdnssd
    kio
    kpackage
    kstatusnotifieritem
    ktexteditor
    threadweaver
  ])
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]);

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    kdoctools
    qttools
    wrapQtAppsHook
  ]);

  env.LANG = "C.UTF-8";

  postInstall = ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    )
  '';

  meta = {
    homepage = "https://amarok.kde.org";
    description = "Powerful music player with an intuitive interface";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "amarok";
  };
})
