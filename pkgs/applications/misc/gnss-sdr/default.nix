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
  name = "gnss-sdr-${version}";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "gnss-sdr";
    repo = "gnss-sdr";
    rev = "v${version}";
    sha256 = "0gis932ly3vk7d5qvznffp54pkmbw3m6v60mxjfdj5dd3r7vf975";
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
    homepage = http://gnss-sdr.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
