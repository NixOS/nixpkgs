{
  lib,
  vips,
  resvg,
  mpv,
  libraw,
  imagemagick,
  libdevil,
  stdenv,
  fetchFromGitLab,
  cmake,
  libarchive,
  qt6Packages,
  extra-cmake-modules,
  exiv2,
}:

stdenv.mkDerivation rec {
  pname = "previewqt";
  version = "3.0";

  src = fetchFromGitLab {
    owner = "lspies";
    repo = "previewqt";
    rev = "refs/tags/v${version}";
    hash = "sha256-cDtqgezKGgSdhw8x1mM4cZ0H3SfUPEyWP6rRD+kRwXc=";
  };

  # can't find qtquick3d
  strictDeps = false;

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    exiv2
    imagemagick
    qt6Packages.poppler
    qt6Packages.qtmultimedia
    qt6Packages.qtquick3d
    qt6Packages.qtsvg
    qt6Packages.qttools
    qt6Packages.qtwebengine
    libarchive
    libdevil
    libraw
    mpv
    resvg
    vips
  ];

  meta = {
    description = "Qt-based file previewer";
    homepage = "https://photoqt.org/previewqt";
    changelog = "https://gitlab.com/lspies/previewqt/-/blob/v${version}/CHANGELOG";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "previewqt";
    platforms = lib.platforms.linux;
  };
}
