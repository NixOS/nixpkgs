{
  lib,
  fetchFromGitHub,
  armadillo,
  cmake,
  gmp,
  glog,
  gtest,
  openssl,
  gflags,
  gnuradio,
  thrift,
  enableRawUdp ? true,
  libpcap,
  orc,
  pkg-config,
  blas,
  lapack,
  matio,
  pugixml,
  protobuf,
  enableOsmosdr ? true,
}:

gnuradio.pkgs.mkDerivation rec {
  pname = "gnss-sdr";
  version = "0.0.20";

  src = fetchFromGitHub {
    owner = "gnss-sdr";
    repo = "gnss-sdr";
    rev = "v${version}";
    hash = "sha256-kQv8I4dcWeRuAfYtD5EAAMwvfnOTi+QWDogUZb4M/qQ=";
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
    gnuradio.unwrapped.python.pkgs.mako
    gnuradio.unwrapped.python.pkgs.six
  ];
  nativeCheckInputs = [
    gtest
  ];

  buildInputs = [
    gmp
    armadillo
    glog
    gflags
    openssl
    orc
    blas
    lapack
    matio
    pugixml
    protobuf
    gnuradio.unwrapped.boost
    gnuradio.unwrapped.logLib
  ]
  ++ lib.optionals (gnuradio.hasFeature "gr-uhd") [
    gnuradio.unwrapped.uhd
  ]
  ++ lib.optionals enableRawUdp [
    libpcap
  ]
  ++ lib.optionals (gnuradio.hasFeature "gr-ctrlport") [
    thrift
    gnuradio.unwrapped.python.pkgs.thrift
  ]
  ++ lib.optionals (gnuradio.hasFeature "gr-pdu" || gnuradio.hasFeature "gr-iio") [
    gnuradio.unwrapped.libiio
  ]
  ++ lib.optionals (gnuradio.hasFeature "gr-pdu") [
    gnuradio.unwrapped.libad9361
  ]
  ++ lib.optionals enableOsmosdr [
    gnuradio.pkgs.osmosdr
  ];

  cmakeFlags = [
    (lib.cmakeFeature "GFlags_INCLUDE_DIRS" "${gflags}/include")
    (lib.cmakeFeature "GLOG_INCLUDE_DIR" "${glog}/include")
    # Should use .dylib if darwin support is requested
    (lib.cmakeFeature "GFlags_LIBS" "${gflags}/lib/libgflags.so")
    (lib.cmakeFeature "-DGLOG_LIBRARIES" "${glog}/lib/libglog.so")
    # Use our dependencies glog, gflags and armadillo dependencies
    (lib.cmakeBool "ENABLE_OWN_GLOG" false)
    (lib.cmakeBool "ENABLE_OWN_ARMADILLO" false)
    (lib.cmakeBool "ENABLE_ORC" true)
    (lib.cmakeBool "ENABLE_LOG" true)
    (lib.cmakeBool "ENABLE_RAW_UDP" enableRawUdp)
    (lib.cmakeBool "ENABLE_UHD" (gnuradio.hasFeature "gr-uhd"))
    (lib.cmakeBool "ENABLE_FMCOMMS2" (gnuradio.hasFeature "gr-iio" && gnuradio.hasFeature "gr-pdu"))
    (lib.cmakeBool "ENABLE_PLUTOSDR" (gnuradio.hasFeature "gr-iio"))
    (lib.cmakeBool "ENABLE_OSMOSDR" enableOsmosdr)
    (lib.cmakeBool "ENABLE_UNIT_TESTING" false)

    # Requires unpackaged gnsstk
    # Only relevant if you want to run gnss-sdr on FPGA SoCs like Zynq
    # (lib.cmakeBool "ENABLE_AD9361" (gnuradio.hasFeature "gr-pdu"))

    # gnss-sdr doesn't truly depend on BLAS or LAPACK, as long as
    # armadillo is built using both, so skip checking for them.
    (lib.cmakeFeature "BLAS_LIBRARIES" "-lblas")
    (lib.cmakeFeature "LAPACK_LIBRARIES" "-llapack")
  ];

  meta = with lib; {
    description = "Open source Global Navigation Satellite Systems software-defined receiver";
    homepage = "https://gnss-sdr.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
