{ stdenv, fetchFromGitHub
, armadillo
, boost
, cmake
, glog
, gmock
, openssl
, google-gflags
, gnuradio
, orc
, pkgconfig
, pythonPackages
, uhd
}:

stdenv.mkDerivation rec {
  pname = "gnss-sdr";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0mnvwnns6dnf2g6lmiwmm43i8gzxx4wdmskkfzyjaq4js5x5kvzg";
  };

  buildInputs = [
    armadillo
    boost.dev
    cmake
    glog
    gmock
    openssl.dev
    google-gflags
    gnuradio
    orc
    pkgconfig
    pythonPackages.Mako

    # UHD support is optional, but gnuradio is built with it, so there's
    # nothing to be gained by leaving it out.
    uhd
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DGFlags_ROOT_DIR=${google-gflags}/lib"
    "-DGLOG_INCLUDE_DIR=${glog}/include"
    "-DENABLE_UNIT_TESTING=OFF"

    # gnss-sdr doesn't truly depend on BLAS or LAPACK, as long as
    # armadillo is built using both, so skip checking for them.
    "-DBLAS=YES"
    "-DLAPACK=YES"

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
