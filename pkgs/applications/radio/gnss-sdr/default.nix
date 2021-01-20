{ lib, stdenv, fetchFromGitHub
, armadillo
, boost
, cmake
, glog
, gmock
, openssl
, gflags
, gnuradio
, orc
, pkg-config
, pythonPackages
, uhd
, log4cpp
, blas, lapack
, matio
, pugixml
, protobuf
}:

stdenv.mkDerivation rec {
  pname = "gnss-sdr";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "gnss-sdr";
    repo = "gnss-sdr";
    rev = "v${version}";
    sha256 = "0a3k47fl5dizzhbqbrbmckl636lznyjby2d2nz6fz21637hvrnby";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    armadillo
    boost.dev
    glog
    gmock
    openssl.dev
    gflags
    gnuradio
    orc
    pythonPackages.Mako
    pythonPackages.six

    # UHD support is optional, but gnuradio is built with it, so there's
    # nothing to be gained by leaving it out.
    uhd
    log4cpp
    blas lapack
    matio
    pugixml
    protobuf
  ];

  cmakeFlags = [
    "-DGFlags_ROOT_DIR=${gflags}/lib"
    "-DGLOG_INCLUDE_DIR=${glog}/include"
    "-DENABLE_UNIT_TESTING=OFF"

    # gnss-sdr doesn't truly depend on BLAS or LAPACK, as long as
    # armadillo is built using both, so skip checking for them.
    "-DBLAS=YES"
    "-DLAPACK=YES"
    "-DBLAS_LIBRARIES=-lblas"
    "-DLAPACK_LIBRARIES=-llapack"

    # Similarly, it doesn't actually use gfortran despite checking for
    # its presence.
    "-DGFORTRAN=YES"
  ];

  meta = with lib; {
    description = "An open source Global Navigation Satellite Systems software-defined receiver";
    homepage = "https://gnss-sdr.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
