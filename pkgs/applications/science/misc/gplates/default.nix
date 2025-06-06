{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, graphviz
, boost
, cgal_5
, gdal
, glew
, gmp
, libGL
, libGLU
, libSM
, mpfr
, proj
, python3
, qtxmlpatterns
, qwt
, wrapQtAppsHook
}:

let
  python = python3.withPackages (ps: with ps; [
    numpy
  ]);
  boost' = boost.override {
    enablePython = true;
    inherit python;
  };
  cgal = cgal_5.override {
    boost = boost';
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "gplates";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "GPlates";
    repo = "GPlates";
    rev = "GPlates-${finalAttrs.version}";
    hash = "sha256-3fEwm5EKK9RcRbnyUejgwfjdsXaujjZjoMbq/BbVMeM=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    wrapQtAppsHook
  ];

  buildInputs = [
    boost'
    cgal
    gdal
    glew
    gmp
    libGL
    libGLU
    libSM
    mpfr
    proj
    python
    qtxmlpatterns
    qwt
  ];

  meta = with lib; {
    description = "Desktop software for the interactive visualisation of plate-tectonics";
    mainProgram = "gplates";
    homepage = "https://www.gplates.org";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    broken = stdenv.isDarwin; # FIX: this check: https://github.com/GPlates/GPlates/blob/gplates/cmake/modules/Config_h.cmake#L72
  };
})
