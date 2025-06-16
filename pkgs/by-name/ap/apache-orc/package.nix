{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  cmake,
  gtest,
  lz4,
  protobuf_30,
  snappy,
  zlib,
  zstd,
}:

let
  orc-format = fetchurl {
    name = "orc-format-1.1.0.tar.gz";
    url = "https://www.apache.org/dyn/closer.lua/orc/orc-format-1.1.0/orc-format-1.1.0.tar.gz?action=download";
    hash = "sha256-1KesdsVEKr9xGeLLhOcbZ34HWv9TUYqoZgVeLq0EUNc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "apache-orc";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "orc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hNKzqNOagBJOWQRebkVHIuvqfpk9Mi30bu4z7dGbsxk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gtest
    lz4
    protobuf_30
    snappy
    zlib
    zstd
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "BUILD_JAVA" false)
    (lib.cmakeBool "STOP_BUILD_ON_WARNING" true)
    (lib.cmakeBool "INSTALL_VENDORED_LIBS" false)
  ];

  env = {
    GTEST_HOME = gtest.dev;
    LZ4_ROOT = lz4;
    ORC_FORMAT_URL = orc-format;
    PROTOBUF_HOME = protobuf_30;
    SNAPPY_ROOT = snappy.dev;
    ZLIB_ROOT = zlib.dev;
    ZSTD_ROOT = zstd.dev;
  };

  meta = {
    changelog = "https://github.com/apache/orc/releases/tag/v${finalAttrs.version}";
    description = "Smallest, fastest columnar storage for Hadoop workloads";
    homepage = "https://github.com/apache/orc/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
})
