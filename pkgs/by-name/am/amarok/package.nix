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
  pcre,
  snappy,
  taglib,
  taglib_extras,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amarok";
  version = "3.3.0";

  src = fetchurl {
    url = "mirror://kde/stable/amarok/${finalAttrs.version}/amarok-${finalAttrs.version}.tar.xz";
    hash = "sha256-Lc5YezwUv5IOpNiQdpZOuXT8Q0VwFHKA/NHkPPFP8aw=";
  };

  outputs = [
    "out"
    "doc"
  ];

  buildInputs =
    with kdePackages;
    [
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
      pcre
      snappy
      taglib
      taglib_extras
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
    ]);

  nativeBuildInputs = with kdePackages; [
    cmake
    pkg-config
    extra-cmake-modules
    kdoctools
    qttools
    wrapQtAppsHook
  ];

  env.LANG = "C.UTF-8";

  meta = {
    homepage = "https://amarok.kde.org";
    description = "Powerful music player with an intuitive interface";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "amarok";
  };
})
