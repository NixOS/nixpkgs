{
  lib,
  stdenv,
  fetchFromGitHub,
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

stdenv.mkDerivation rec {
  pname = "csxcad";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "CSXCAD";
    rev = "v${version}";
    sha256 = "sha256-SSV5ulx3rCJg99I/oOQbqe+gOSs+BfcCo6UkWHVhnSs=";
  };

  patches = [ ./searchPath.patch ];

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

  meta = with lib; {
    description = "C++ library to describe geometrical objects";
    homepage = "https://github.com/thliebig/CSXCAD";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
