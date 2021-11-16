{ lib
, fetchFromGitHub
, armadillo
, cmake
, gmp
, glog
, gtest
, openssl
, gflags
, gnuradio3_8
, thrift
, libpcap
, orc
, pkg-config
, uhd
, log4cpp
, blas, lapack
, matio
, pugixml
, protobuf
}:

gnuradio3_8.pkgs.mkDerivation rec {
  pname = "gnss-sdr";
  # There's an issue with cpufeatures on 0.0.15, see:
  # https://github.com/NixOS/nixpkgs/pull/142557#issuecomment-950217925
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "gnss-sdr";
    repo = "gnss-sdr";
    rev = "v${version}";
    sha256 = "0a3k47fl5dizzhbqbrbmckl636lznyjby2d2nz6fz21637hvrnby";
  };

  nativeBuildInputs = [
    cmake
    gnuradio3_8.unwrapped.python
    gnuradio3_8.unwrapped.python.pkgs.Mako
    gnuradio3_8.unwrapped.python.pkgs.six
  ];

  buildInputs = [
    gmp
    armadillo
    gnuradio3_8.unwrapped.boost
    glog
    gtest
    openssl
    gflags
    orc
    # UHD support is optional, but gnuradio is built with it, so there's
    # nothing to be gained by leaving it out.
    gnuradio3_8.unwrapped.uhd
    log4cpp
    blas lapack
    matio
    pugixml
    protobuf
    gnuradio3_8.pkgs.osmosdr
    libpcap
  ] ++ lib.optionals (gnuradio3_8.hasFeature "gr-ctrlport") [
    thrift
    gnuradio3_8.unwrapped.python.pkgs.thrift
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
