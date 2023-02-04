{ lib, stdenv
, fetchFromGitHub
, cmake
, fparser
, tinyxml
, hdf5
, cgal_5
, vtk_8
, boost
, gmp
, mpfr
}:

stdenv.mkDerivation rec {
  pname = "csxcad";
  version = "unstable-2020-02-08";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "CSXCAD";
    rev = "ef6e40931dbd80e0959f37c8e9614c437bf7e518";
    sha256 = "072s765jyzpdq8qqysdy0dld17m6sr9zfcs0ip2zk8c4imxaysnb";
  };

  patches = [./searchPath.patch ];

  buildInputs = [
    cgal_5
    boost
    gmp
    mpfr
    vtk_8
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
