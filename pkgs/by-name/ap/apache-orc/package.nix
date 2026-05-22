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
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "orc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QQdRzwmUF1Qwxg53kJv1Q6yFuHqSrLYwUxKt+6wK9Hs=";
  };

  patches = [
    # Orc's CMake declarations do not correctly attempt to link in abseil,
    # so we add the relevant library they need. Without these, we get errors
    # like:
    # <store path>/bin/ld: <store path>/lib/libabsl_raw_hash-set.so.2601.0.0:
    # error adding symbols: DSO missing from command line
    ./cmake-link-abseil.patch

    # Protobuf 34 adds `[[nodiscard]]` to several serialization functions. In
    # order to avoid these warnings causing build failures, we add handling for
    # this failure case.
    ./protobuf34-nodiscard.patch
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

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "BUILD_JAVA" false)
    (lib.cmakeBool "STOP_BUILD_ON_WARNING" stdenv.hostPlatform.isLinux)
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
    LZ4_HOME = lz4;
    ORC_FORMAT_URL = orc-format;
    PROTOBUF_HOME = protobuf;
    SNAPPY_HOME = snappy.dev;
    ZLIB_HOME = zlib.dev;
    ZSTD_HOME = zstd.dev;
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
