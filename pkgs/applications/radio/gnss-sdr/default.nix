{ stdenv, fetchFromGitHub
, armadillo
, boost
, cmake
, glog
, gmock
, openssl
, gflags
, gnuradio
, orc
, pkgconfig
, pythonPackages
, uhd
, log4cpp
, openblas
, matio
, pugixml
, protobuf
}:

stdenv.mkDerivation rec {
  name = "gnss-sdr-${version}";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "gnss-sdr";
    repo = "gnss-sdr";
    rev = "v${version}";
    sha256 = "0ajj0wx68yyzigppxxa1wag3hzkrjj8dqq8k28rj0jhp8a6bw2q7";
  };

  buildInputs = [
    armadillo
    boost.dev
    cmake
    glog
    gmock
    openssl.dev
    gflags
    gnuradio
    orc
    pkgconfig
    pythonPackages.Mako

    # UHD support is optional, but gnuradio is built with it, so there's
    # nothing to be gained by leaving it out.
    uhd
    log4cpp
    openblas
    matio
    pugixml
    protobuf
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DGFlags_ROOT_DIR=${gflags}/lib"
    "-DGLOG_INCLUDE_DIR=${glog}/include"
    "-DENABLE_UNIT_TESTING=OFF"

    # gnss-sdr doesn't truly depend on BLAS or LAPACK, as long as
    # armadillo is built using both, so skip checking for them.
    "-DBLAS=YES"
    "-DLAPACK=YES"
    "-DBLAS_LIBRARIES=-lopenblas"
    "-DLAPACK_LIBRARIES=-lopenblas"

    # Similarly, it doesn't actually use gfortran despite checking for
    # its presence.
    "-DGFORTRAN=YES"
  ];

  meta = with stdenv.lib; {
    description = "An open source Global Navigation Satellite Systems software-defined receiver";
    homepage = https://gnss-sdr.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
