{ lib, stdenv
, fetchFromGitHub
, cmake
, fparser
, tinyxml
, hdf5
, cgal_5
, vtk
, boost
, gmp
, mpfr
}:

stdenv.mkDerivation rec {
  pname = "csxcad";
  version = "unstable-2022-05-18";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "CSXCAD";
    rev = "cd9decb4d9cebe3c8bf115e2c0ee73f730f22da1";
    sha256 = "1604amhvp7dm8ych7gwzxwawqvb9hpjglk5ffd4qm0y3k6r89arn";
  };

  patches = [./searchPath.patch ];

  buildInputs = [
    cgal_5
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
    description = "A C++ library to describe geometrical objects";
    homepage = "https://github.com/thliebig/CSXCAD";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
