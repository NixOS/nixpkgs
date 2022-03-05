{ lib
, fetchFromGitHub
, armadillo
, cmake
, gmp
, glog
, gtest
, openssl
, gflags
, gnuradio
, thrift
, enableRawUdp ? true, libpcap
, orc
, pkg-config
, blas, lapack
, matio
, pugixml
, protobuf
}:

gnuradio.pkgs.mkDerivation rec {
  pname = "gnss-sdr";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "gnss-sdr";
    repo = "gnss-sdr";
    rev = "v${version}";
    sha256 = "sha256-ODe4k6PDGtDX11FrbggEbN3tc4UtATaItUIpCKl4JjM=";
  };

  patches = [
    # Use the relative install location for volk_gnsssdr_module and
    # cpu_features which is bundled in the source. NOTE: Perhaps this patch
    # should be sent upstream.
    ./fix_libcpu_features_install_path.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gnuradio.unwrapped.python
    gnuradio.unwrapped.python.pkgs.Mako
    gnuradio.unwrapped.python.pkgs.six
  ];
  checkInputs = [
    gtest
  ];

  buildInputs = [
    gmp
    armadillo
    glog
    gflags
    openssl
    orc
    blas lapack
    matio
    pugixml
    protobuf
    gnuradio.unwrapped.boost
  ] ++ lib.optionals (gnuradio.hasFeature "gr-uhd") [
    gnuradio.unwrapped.uhd
  ] ++ (if (lib.versionAtLeast gnuradio.unwrapped.versionAttr.major "3.10") then [
    gnuradio.unwrapped.spdlog
  ] else [
    gnuradio.unwrapped.log4cpp
  ]) ++ lib.optionals (enableRawUdp) [
    libpcap
  ] ++ lib.optionals (gnuradio.hasFeature "gr-ctrlport") [
    thrift
    gnuradio.unwrapped.python.pkgs.thrift
  ] ++ lib.optionals (gnuradio.hasFeature "gr-pdu" || gnuradio.hasFeature "gr-iio") [
    gnuradio.unwrapped.libiio
  ] ++ lib.optionals (gnuradio.hasFeature "gr-pdu") [
    gnuradio.unwrapped.libad9361
  ];

  cmakeFlags = [
    "-DGFlags_INCLUDE_DIRS=${gflags}/include"
    "-DGLOG_INCLUDE_DIR=${glog}/include"
    # Should use .dylib if darwin support is requested
    "-DGFlags_LIBS=${gflags}/lib/libgflags.so"
    "-DGLOG_LIBRARIES=${glog}/lib/libglog.so"
    # Use our dependencies glog, gflags and armadillo dependencies
    "-DENABLE_OWN_GLOG=OFF"
    "-DENABLE_OWN_ARMADILLO=OFF"
    "-DENABLE_ORC=ON"
    "-DENABLE_LOG=ON"
    "-DENABLE_RAW_UDP=${if enableRawUdp then "ON" else "OFF"}"
    "-DENABLE_UHD=${if (gnuradio.hasFeature "gr-uhd") then "ON" else "OFF"}"
    "-DENABLE_FMCOMMS2=${if (gnuradio.hasFeature "gr-iio" && gnuradio.hasFeature "gr-pdu") then "ON" else "OFF"}"
    "-DENABLE_PLUTOSDR=${if (gnuradio.hasFeature "gr-iio") then "ON" else "OFF"}"
    "-DENABLE_AD9361=${if (gnuradio.hasFeature "gr-pdu") then "ON" else "OFF"}"
    "-DENABLE_UNIT_TESTING=OFF"

    # gnss-sdr doesn't truly depend on BLAS or LAPACK, as long as
    # armadillo is built using both, so skip checking for them.
    "-DBLAS_LIBRARIES=-lblas"
    "-DLAPACK_LIBRARIES=-llapack"
  ];

  meta = with lib; {
    description = "An open source Global Navigation Satellite Systems software-defined receiver";
    homepage = "https://gnss-sdr.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
