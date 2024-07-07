{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "qwt-6.3-compile-error-fix.patch";
      url = "https://github.com/GPlates/GPlates/commit/c4680ebe54f4535909085feacecd66410a91ff98.patch";
      hash = "sha256-mw5+GLayMrmcSDd1ai+0JTuY3iedHT9u2kx5Dd2wMjg=";
    })
  ];

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
