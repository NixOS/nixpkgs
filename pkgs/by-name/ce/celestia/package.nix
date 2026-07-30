{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libglut,
  libjpeg_turbo,
  lua,
  libGLU,
  libGL,
  perl,
  eigen,
  freetype,
  cmake,
  libepoxy,
  libpng,
  boost,
  fmt,
  libavif,
  ffmpeg,
  gperf,
  gettext,
  qt6Packages,
  callPackage,
  celestia-content ? callPackage ./content.nix { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "celestia";
  version = "1.6.4-unstable-2026-07-02";

  src = fetchFromGitHub {
    owner = "CelestiaProject";
    repo = "Celestia";
    rev = "ded2c69ec7b819640a6c807fc7d4280bbf08e26b";
    hash = "sha256-GDp31jwY9ifppUJ3Yy84E+x33O4+UmR/ODrHwH2HyeM=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    cmake
    gperf
    gettext
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtbase
    libglut
    lua
    perl
    libjpeg_turbo
    eigen
    libepoxy
    libpng
    fmt
    boost
    libavif
    ffmpeg
    freetype
    libGLU
    libGL
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ENABLE_QT6" "ON")
    (lib.cmakeFeature "ENABLE_FFMPEG" "ON")
    (lib.cmakeFeature "ENABLE_LIBAVIF" "ON")
    (lib.cmakeFeature "GIT_COMMIT" "${finalAttrs.src.rev}")
  ];

  enableParallelBuilding = true;

  qtWrapperArgs = [
    "--unset"
    "QT_QPA_PLATFORMTHEME"
    "--unset"
    "QT_STYLE_OVERRIDE"
  ];

  postInstall = ''
    cp -r ${celestia-content}/share/celestia/* $out/share/celestia
    cp -r ${celestia-content}/share/locale/* $out/share/locale
  '';

  meta = {
    homepage = "https://celestiaproject.space/";
    description = "Real-time 3D simulation of space";
    mainProgram = "celestia";
    # no tagged release for ages, remove this for now
    # changelog = "https://github.com/CelestiaProject/Celestia/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      returntoreality
      pancaek
    ];
    platforms = lib.platforms.linux;
  };
})
