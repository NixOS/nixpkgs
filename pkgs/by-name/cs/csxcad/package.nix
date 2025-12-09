{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  fparser,
  tinyxml,
  hdf5,
  cgal,
  vtk,
  boost,
  gmp,
  mpfr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csxcad";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "CSXCAD";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-SSV5ulx3rCJg99I/oOQbqe+gOSs+BfcCo6UkWHVhnSs=";
  };

  patches = [
    ./searchPath.patch
    # ref. https://github.com/thliebig/CSXCAD/pull/62 merged upstream
    (fetchpatch {
      name = "update-cmake-minimum-required.patch";
      url = "https://github.com/thliebig/CSXCAD/commit/b8ea64e11320910109a49b6da5352e1a1a18a736.patch";
      hash = "sha256-mpQmpvrEDjOKgEAZ5laIIepG+PWqSr637tOY7FQst2s=";
    })
  ];

  buildInputs = [
    cgal
    boost
    gmp
    mpfr
    vtk
    fparser
    tinyxml
    hdf5
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C++ library to describe geometrical objects";
    homepage = "https://github.com/thliebig/CSXCAD";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.linux;
  };
})
