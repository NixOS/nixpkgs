{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  graphviz,
  boost,
  cgal,
  gdal,
  glew,
  gmp,
  libGL,
  libGLU,
  libsm,
  mpfr,
  proj,
  python3,
  qt6Packages,
  gtk3,
  wrapGAppsHook3,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      numpy
    ]
  );
  boost' = boost.override {
    enablePython = true;
    inherit python;
  };
  cgal' = cgal.override {
    boost = boost';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gplates";
  version = "2.6.0-unstable-2026-08-18";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "GPlates";
    repo = "GPlates";
    rev = "3c3f1a7c8faaecf8e3bb9991b998b41052beda50";
    hash = "sha256-Glu4KlD+U+bLciFtNMZWqFwJgTpFLECI11TbJX+9fwQ=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    python
    wrapGAppsHook3
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    boost'
    cgal'
    gdal
    glew
    gmp
    gtk3
    libGL
    libGLU
    libsm
    mpfr
    proj
    python
    qt6Packages.qt5compat
    qt6Packages.qwt
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --set PYTHONHOME "${python}"
      --set PYTHONPATH "${python}/${python.sitePackages}"
    )
  '';

  meta = {
    description = "Desktop software for the interactive visualisation of plate-tectonics";
    mainProgram = "gplates";
    homepage = "https://www.gplates.org";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # FIX: this check: https://github.com/GPlates/GPlates/blob/gplates/cmake/modules/Config_h.cmake#L72
  };
})
