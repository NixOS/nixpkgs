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
  version = "2.6.0-47";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "GPlates";
    repo = "GPlates";
    tag = "GPlates-${finalAttrs.version}";
    hash = "sha256-sKhOMZm5ctXTxq0sLw1iDaqxf76yw4iFEorQ8jupGHk=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    python
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
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
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
