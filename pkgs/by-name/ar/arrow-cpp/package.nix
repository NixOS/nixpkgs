{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  fixDarwinDylibNames,
  autoconf,
  aws-sdk-cpp,
  aws-sdk-cpp-arrow ? aws-sdk-cpp.override {
    apis = [
      "cognito-identity"
      "config"
      "identity-management"
      "s3"
      "sts"
      "transfer"
    ];
  },
  boost,
  brotli,
  bzip2,
  c-ares,
  cmake,
  crc32c,
  curl,
  flatbuffers,
  gflags,
  glog,
  google-cloud-cpp,
  grpc,
  gtest,
  libbacktrace,
  lz4,
  minio,
  ninja,
  nlohmann_json,
  openssl,
  perl,
  protobuf,
  python3,
  rapidjson,
  re2,
  snappy,
  sqlite,
  thrift,
  tzdata,
  utf8proc,
  which,
  zlib,
  zstd,
  testers,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableFlight ? true,
  enableJemalloc ? !stdenv.isDarwin,
  enableS3 ? true,
  enableGcs ? !stdenv.isDarwin,
}:

assert lib.asserts.assertMsg (
  (enableS3 && stdenv.isDarwin)
  -> (lib.versionOlder boost.version "1.69" || lib.versionAtLeast boost.version "1.70")
) "S3 on Darwin requires Boost != 1.69";

let
  arrow-testing = fetchFromGitHub {
    name = "arrow-testing";
    owner = "apache";
    repo = "arrow-testing";
    rev = "25d16511e8d42c2744a1d94d90169e3a36e92631";
    hash = "sha256-fXeWM/8jBfJY7KL6PVfRbzB8i4sp6PHsnMSHCX5kzfI=";
  };

  parquet-testing = fetchFromGitHub {
    name = "parquet-testing";
    owner = "apache";
    repo = "parquet-testing";
    rev = "74278bc4a1122d74945969e6dec405abd1533ec3";
    hash = "sha256-WbpndtAviph6+I/F2bevuMI9DkfSv4SMPgMaP98k6Qo=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "arrow-cpp";
  version = "16.0.0";

  src = fetchurl {
    url = "mirror://apache/arrow/arrow-${finalAttrs.version}/apache-arrow-${finalAttrs.version}.tar.gz";
    hash = "sha256-n0BRrpRzyXmR2a+AHi+UrjRVBncZyn+QuBN/nppwC40=";
  };

  sourceRoot = "apache-arrow-${finalAttrs.version}/cpp";

  # versions are all taken from
  # https://github.com/apache/arrow/blob/apache-arrow-${version}/cpp/thirdparty/versions.txt

  # jemalloc: arrow uses a custom prefix to prevent default allocator symbol
  # collisions as well as custom build flags
  ${if enableJemalloc then "ARROW_JEMALLOC_URL" else null} = fetchurl {
    url = "https://github.com/jemalloc/jemalloc/releases/download/5.3.0/jemalloc-5.3.0.tar.bz2";
    hash = "sha256-LbgtHnEZ3z5xt2QCGbbf6EeJvAU3mDw7esT3GJrs/qo=";
  };

  # mimalloc: arrow uses custom build flags for mimalloc
  ARROW_MIMALLOC_URL = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    rev = "v2.0.6";
    hash = "sha256-u2ITXABBN/dwU+mCIbL3tN1f4c17aBuSdNTV+Adtohc=";
  };

  ARROW_XSIMD_URL = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = "9.0.1";
    hash = "sha256-onALN6agtrHWigtFlCeefD9CiRZI4Y690XTzy2UDnrk=";
  };

  ARROW_SUBSTRAIT_URL = fetchFromGitHub {
    owner = "substrait-io";
    repo = "substrait";
    rev = "v0.44.0";
    hash = "sha256-V739IFTGPtbGPlxcOi8sAaYSDhNUEpITvN9IqdPReug=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    autoconf # for vendored jemalloc
    flatbuffers
  ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs =
    [
      boost
      brotli
      bzip2
      flatbuffers
      gflags
      glog
      gtest
      libbacktrace
      lz4
      nlohmann_json # alternative JSON parser to rapidjson
      protobuf # substrait requires protobuf
      rapidjson
      re2
      snappy
      thrift
      utf8proc
      zlib
      zstd
    ]
    ++ lib.optionals enableFlight [
      grpc
      openssl
      protobuf
      sqlite
    ]
    ++ lib.optionals enableS3 [
      aws-sdk-cpp-arrow
      openssl
    ]
    ++ lib.optionals enableGcs [
      crc32c
      curl
      google-cloud-cpp
      grpc
      nlohmann_json
    ];

  preConfigure = ''
    patchShebangs build-support/
    substituteInPlace "src/arrow/vendored/datetime/tz.cpp" \
      --replace 'discover_tz_dir();' '"${tzdata}/share/zoneinfo";'
  '';

  cmakeFlags =
    [
      "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
      "-DARROW_BUILD_SHARED=${if enableShared then "ON" else "OFF"}"
      "-DARROW_BUILD_STATIC=${if enableShared then "OFF" else "ON"}"
      "-DARROW_BUILD_TESTS=ON"
      "-DARROW_BUILD_INTEGRATION=ON"
      "-DARROW_BUILD_UTILITIES=ON"
      "-DARROW_EXTRA_ERROR_CONTEXT=ON"
      "-DARROW_VERBOSE_THIRDPARTY_BUILD=ON"
      "-DARROW_DEPENDENCY_SOURCE=SYSTEM"
      "-Dxsimd_SOURCE=AUTO"
      "-DARROW_DEPENDENCY_USE_SHARED=${if enableShared then "ON" else "OFF"}"
      "-DARROW_COMPUTE=ON"
      "-DARROW_CSV=ON"
      "-DARROW_DATASET=ON"
      "-DARROW_FILESYSTEM=ON"
      "-DARROW_FLIGHT_SQL=${if enableFlight then "ON" else "OFF"}"
      "-DARROW_HDFS=ON"
      "-DARROW_IPC=ON"
      "-DARROW_JEMALLOC=${if enableJemalloc then "ON" else "OFF"}"
      "-DARROW_JSON=ON"
      "-DARROW_USE_GLOG=ON"
      "-DARROW_WITH_BACKTRACE=ON"
      "-DARROW_WITH_BROTLI=ON"
      "-DARROW_WITH_BZ2=ON"
      "-DARROW_WITH_LZ4=ON"
      "-DARROW_WITH_NLOHMANN_JSON=ON"
      "-DARROW_WITH_SNAPPY=ON"
      "-DARROW_WITH_UTF8PROC=ON"
      "-DARROW_WITH_ZLIB=ON"
      "-DARROW_WITH_ZSTD=ON"
      "-DARROW_MIMALLOC=ON"
      "-DARROW_SUBSTRAIT=ON"
      "-DARROW_FLIGHT=${if enableFlight then "ON" else "OFF"}"
      "-DARROW_FLIGHT_TESTING=${if enableFlight then "ON" else "OFF"}"
      "-DARROW_S3=${if enableS3 then "ON" else "OFF"}"
      "-DARROW_GCS=${if enableGcs then "ON" else "OFF"}"
      # Parquet options:
      "-DARROW_PARQUET=ON"
      "-DPARQUET_BUILD_EXECUTABLES=ON"
      "-DPARQUET_REQUIRE_ENCRYPTION=ON"
    ]
    ++ lib.optionals (!enableShared) [
      "-DARROW_TEST_LINKAGE=static"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "-DCMAKE_INSTALL_RPATH=@loader_path/../lib" # needed for tools executables
    ]
    ++ lib.optionals (!stdenv.isx86_64) [ "-DARROW_USE_SIMD=OFF" ]
    ++ lib.optionals enableS3 [
      "-DAWSSDK_CORE_HEADER_FILE=${aws-sdk-cpp-arrow}/include/aws/core/Aws.h"
    ];

  doInstallCheck = true;
  ARROW_TEST_DATA = lib.optionalString finalAttrs.doInstallCheck "${arrow-testing}/data";
  PARQUET_TEST_DATA = lib.optionalString finalAttrs.doInstallCheck "${parquet-testing}/data";
  GTEST_FILTER =
    let
      # Upstream Issue: https://issues.apache.org/jira/browse/ARROW-11398
      filteredTests =
        lib.optionals stdenv.hostPlatform.isAarch64 [
          "TestFilterKernelWithNumeric/3.CompareArrayAndFilterRandomNumeric"
          "TestFilterKernelWithNumeric/7.CompareArrayAndFilterRandomNumeric"
          "TestCompareKernel.PrimitiveRandomTests"
        ]
        ++ lib.optionals enableS3 [
          "S3OptionsTest.FromUri"
          "S3RegionResolutionTest.NonExistentBucket"
          "S3RegionResolutionTest.PublicBucket"
          "S3RegionResolutionTest.RestrictedBucket"
          "TestMinioServer.Connect"
          "TestS3FS.*"
          "TestS3FSGeneric.*"
        ]
        ++ lib.optionals stdenv.isDarwin [
          # TODO: revisit at 12.0.0 or when
          # https://github.com/apache/arrow/commit/295c6644ca6b67c95a662410b2c7faea0920c989
          # is available, see
          # https://github.com/apache/arrow/pull/15288#discussion_r1071244661
          "ExecPlanExecution.StressSourceSinkStopped"
        ];
    in
    lib.optionalString finalAttrs.doInstallCheck "-${lib.concatStringsSep ":" filteredTests}";

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs =
    [
      perl
      which
      sqlite
    ]
    ++ lib.optionals enableS3 [ minio ]
    ++ lib.optionals enableFlight [ python3 ];

  installCheckPhase =
    let
      disabledTests = [
        # flaky
        "arrow-flight-test"
        # requires networking
        "arrow-gcsfs-test"
        "arrow-flight-integration-test"
      ];
    in
    ''
      runHook preInstallCheck

      ctest -L unittest --exclude-regex '^(${lib.concatStringsSep "|" disabledTests})$'

      runHook postInstallCheck
    '';

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/docs/cpp/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      tobim
      veprbl
      cpcloud
    ];
    pkgConfigModules = [
      "arrow"
      "arrow-acero"
      "arrow-compute"
      "arrow-csv"
      "arrow-dataset"
      "arrow-filesystem"
      "arrow-flight"
      "arrow-flight-sql"
      "arrow-flight-testing"
      "arrow-json"
      "arrow-substrait"
      "arrow-testing"
      "parquet"
    ];
  };
  passthru = {
    inherit
      enableFlight
      enableJemalloc
      enableS3
      enableGcs
      ;
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };
})
