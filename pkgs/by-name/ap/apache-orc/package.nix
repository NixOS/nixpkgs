{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  gtest,
  lz4,
  protobuf,
  snappy,
  zlib,
  zstd,
}:

let
  orc-format =
    let
      version = "1.1.1";
      name = "orc-format-${version}";
      archiveName = "${name}.tar.gz";
    in
    fetchurl {
      name = archiveName;
      url = "https://www.apache.org/dyn/closer.lua/orc/${name}/${archiveName}?action=download";
      hash = "sha256-WE3+KkIClGF4/Y/H0SOb54BbntRZarIELe5znniAmSs=";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "apache-orc";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "orc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H7nowl2pq31RIAmTUz15x48Wc99MljFJboc4F7Ln/zk=";
  };

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

  cmakeFlags = [
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
    description = "Smallest, fastest columnar storage for Hadoop workloads";
    homepage = "https://github.com/apache/orc/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
