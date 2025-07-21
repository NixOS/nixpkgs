{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  cmake,
  gtest,
  lz4,
  protobuf,
  snappy,
  zlib,
  zstd,
}:

let
  orc-format = fetchurl {
    name = "orc-format-1.0.0.tar.gz";
    url = "https://www.apache.org/dyn/closer.lua/orc/orc-format-1.0.0/orc-format-1.0.0.tar.gz?action=download";
    hash = "sha256-c5+uX/lLH4ErQTB3KANhBFv5LlEO8Es0phDiOpRdjNU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "apache-orc";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "orc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ib02mIUQaLEVwIBv5xdKDyX+FeI8vhh9+5hM7miKwHo=";
  };

  patches = [
    # Patch that adds 2 missing imports in source files
    # To be removed this PR land: https://github.com/apache/orc/pull/2175
    (fetchpatch {
      url = "https://github.com/apache/orc/commit/fb20db2440226da6b92d38ce260e5b850d2f0092.patch";
      hash = "sha256-rHGECXJoBPgZ62yZciYdSMq4pGnVt75lxkHyO46IiyQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gtest
    lz4
    protobuf
    snappy
    zlib
    zstd
  ];

  cmakeFlags =
    [
      (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
      (lib.cmakeBool "BUILD_JAVA" false)
      (lib.cmakeBool "STOP_BUILD_ON_WARNING" true)
      (lib.cmakeBool "INSTALL_VENDORED_LIBS" false)
    ]
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) [
      # Fix (RiscV) cross-compilation
      # See https://github.com/apache/orc/issues/2334
      (lib.cmakeFeature "HAS_PRE_1970_EXITCODE" "0")
      (lib.cmakeFeature "HAS_POST_2038_EXITCODE" "0")
      (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-unused-parameter")
    ];

  env = {
    GTEST_HOME = gtest.dev;
    LZ4_ROOT = lz4;
    ORC_FORMAT_URL = orc-format;
    PROTOBUF_HOME = protobuf;
    SNAPPY_ROOT = snappy.dev;
    ZLIB_ROOT = zlib.dev;
    ZSTD_ROOT = zstd.dev;
  };

  meta = {
    changelog = "https://github.com/apache/orc/releases/tag/v${finalAttrs.version}";
    description = "The smallest, fastest columnar storage for Hadoop workloads";
    homepage = "https://github.com/apache/orc/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
})
