{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  fixDarwinDylibNames,
  apache-orc,
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
<<<<<<< HEAD
  azure-sdk-for-cpp,
  azurite,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  boost,
  brotli,
  bzip2,
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
  pkg-config,
<<<<<<< HEAD
  protobuf,
=======
  protobuf_31,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
  enableFlight ? stdenv.buildPlatform == stdenv.hostPlatform,
  # Disable also on RiscV
  # configure: error: cannot determine number of significant virtual address bits
  enableJemalloc ?
    !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isRiscV64,
  enableS3 ? true,
  # google-cloud-cpp fails to build on RiscV
<<<<<<< HEAD
  enableGcs ? !stdenv.hostPlatform.isRiscV64,
  enableAzure ? true,
=======
  enableGcs ? !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isRiscV64,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

let
  arrow-testing = fetchFromGitHub {
    name = "arrow-testing";
    owner = "apache";
    repo = "arrow-testing";
<<<<<<< HEAD
    rev = "9a02925d1ba80bd493b6d4da6e8a777588d57ac4";
    hash = "sha256-dEFCkeQpQrU61uCwJp/XB2umbQHjXtzado36BGChoc0=";
=======
    rev = "d2a13712303498963395318a4eb42872e66aead7";
    hash = "sha256-c8FL37kG0uo7o0Zp71WjCl7FD5BnVgqUCCXXX9gI0lg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  parquet-testing = fetchFromGitHub {
    name = "parquet-testing";
    owner = "apache";
    repo = "parquet-testing";
<<<<<<< HEAD
    rev = "a3d96a65e11e2bbca7d22a894e8313ede90a33a3";
    hash = "sha256-Xd6o3RT6Q0tPutV77J0P1x3F6U3RHdCBOKGUKtkQCKk=";
  };

  version = "22.0.0";
=======
    rev = "18d17540097fca7c40be3d42c167e6bfad90763c";
    hash = "sha256-gKEQc2RKpVp39RmuZbIeIXAwiAXDHGnLXF6VQuJtnRA=";
  };

  version = "20.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
stdenv.mkDerivation (finalAttrs: {
  pname = "arrow-cpp";
  inherit version;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow";
    rev = "apache-arrow-${version}";
<<<<<<< HEAD
    hash = "sha256-i4Smt43oi4sddUt3qH7ePjensBSfPW+w/ExLVcVNKic=";
=======
    hash = "sha256-JFPdKraCU+xRkBTAHyY4QGnBVlOjQ1P5+gq9uxyqJtk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "${finalAttrs.src.name}/cpp";

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
<<<<<<< HEAD
    tag = "v3.1.5";
    hash = "sha256-fk6nfyBFS1G0sJwUJVgTC1+aKd0We/JjsIYTO+IOfyg=";
=======
    rev = "v2.0.6";
    hash = "sha256-u2ITXABBN/dwU+mCIbL3tN1f4c17aBuSdNTV+Adtohc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  ARROW_XSIMD_URL = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
<<<<<<< HEAD
    tag = "13.0.0";
=======
    rev = "13.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-qElJYW5QDj3s59L3NgZj5zkhnUMzIP2mBa1sPks3/CE=";
  };

  ARROW_SUBSTRAIT_URL = fetchFromGitHub {
    owner = "substrait-io";
    repo = "substrait";
<<<<<<< HEAD
    tag = "v0.44.0";
=======
    rev = "v0.44.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-V739IFTGPtbGPlxcOi8sAaYSDhNUEpITvN9IqdPReug=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    autoconf # for vendored jemalloc
    flatbuffers
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = [
    apache-orc
    boost
    brotli
    bzip2
<<<<<<< HEAD
    curl
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    flatbuffers
    gflags
    glog
    gtest
    libbacktrace
    lz4
    nlohmann_json # alternative JSON parser to rapidjson
<<<<<<< HEAD
    protobuf # substrait requires protobuf
=======
    protobuf_31 # substrait requires protobuf
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    protobuf
=======
    protobuf_31
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sqlite
  ]
  ++ lib.optionals enableS3 [
    aws-sdk-cpp-arrow
    openssl
  ]
  ++ lib.optionals enableGcs [
    crc32c
<<<<<<< HEAD
    google-cloud-cpp
    grpc
    nlohmann_json
  ]
  ++ lib.optionals enableAzure [
    azure-sdk-for-cpp.identity
    azure-sdk-for-cpp.storage-blobs
    azure-sdk-for-cpp.storage-files-datalake
=======
    curl
    google-cloud-cpp
    grpc
    nlohmann_json
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  # apache-orc looks for things in caps
  env = {
    LZ4_ROOT = lz4;
    ZSTD_ROOT = zstd.dev;
  };

  # fails tests on glibc with this enabled
  hardeningDisable = [ "glibcxxassertions" ];

  preConfigure = ''
    patchShebangs build-support/
    substituteInPlace "src/arrow/vendored/datetime/tz.cpp" \
      --replace-fail 'discover_tz_dir();' '"${tzdata}/share/zoneinfo";'
  '';

  cmakeFlags = [
<<<<<<< HEAD
    (lib.cmakeBool "CMAKE_FIND_PACKAGE_PREFER_CONFIG" true)
    (lib.cmakeBool "ARROW_BUILD_SHARED" enableShared)
    (lib.cmakeBool "ARROW_BUILD_STATIC" (!enableShared))
    (lib.cmakeBool "ARROW_BUILD_TESTS" enableShared)
    (lib.cmakeBool "ARROW_BUILD_INTEGRATION" true)
    (lib.cmakeBool "ARROW_BUILD_UTILITIES" true)
    (lib.cmakeBool "ARROW_EXTRA_ERROR_CONTEXT" true)
    (lib.cmakeBool "ARROW_VERBOSE_THIRDPARTY_BUILD" true)
    (lib.cmakeFeature "ARROW_DEPENDENCY_SOURCE" "SYSTEM")
    (lib.cmakeFeature "xsimd_SOURCE" "AUTO")
    (lib.cmakeBool "ARROW_DEPENDENCY_USE_SHARED" enableShared)
    (lib.cmakeBool "ARROW_COMPUTE" true)
    (lib.cmakeBool "ARROW_CSV" true)
    (lib.cmakeBool "ARROW_DATASET" true)
    (lib.cmakeBool "ARROW_FILESYSTEM" true)
    (lib.cmakeBool "ARROW_FLIGHT_SQL" enableFlight)
    (lib.cmakeBool "ARROW_HDFS" true)
    (lib.cmakeBool "ARROW_IPC" true)
    (lib.cmakeBool "ARROW_JEMALLOC" enableJemalloc)
    (lib.cmakeBool "ARROW_JSON" true)
    (lib.cmakeBool "ARROW_USE_GLOG" true)
    (lib.cmakeBool "ARROW_WITH_BACKTRACE" true)
    (lib.cmakeBool "ARROW_WITH_BROTLI" true)
    (lib.cmakeBool "ARROW_WITH_BZ2" true)
    (lib.cmakeBool "ARROW_WITH_LZ4" true)
    (lib.cmakeBool "ARROW_WITH_NLOHMANN_JSON" true)
    (lib.cmakeBool "ARROW_WITH_SNAPPY" true)
    (lib.cmakeBool "ARROW_WITH_UTF8PROC" true)
    (lib.cmakeBool "ARROW_WITH_ZLIB" true)
    (lib.cmakeBool "ARROW_WITH_ZSTD" true)
    (lib.cmakeBool "ARROW_MIMALLOC" true)
    (lib.cmakeBool "ARROW_SUBSTRAIT" true)
    (lib.cmakeBool "ARROW_FLIGHT" enableFlight)
    (lib.cmakeBool "ARROW_FLIGHT_TESTING" enableFlight)
    (lib.cmakeBool "ARROW_S3" enableS3)
    (lib.cmakeBool "ARROW_GCS" enableGcs)
    (lib.cmakeBool "ARROW_AZURE" enableAzure)
    (lib.cmakeBool "ARROW_ORC" true)
    # Parquet options:
    (lib.cmakeBool "ARROW_PARQUET" true)
    (lib.cmakeBool "PARQUET_BUILD_EXECUTABLES" true)
    (lib.cmakeBool "PARQUET_REQUIRE_ENCRYPTION" true)
  ]
  ++ lib.optionals (!enableShared) [
    (lib.cmakeFeature "ARROW_TEST_LINKAGE" "static")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # needed for tools executables
    (lib.cmakeFeature "CMAKE_INSTALL_RPATH" "@loader_path/../lib")
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [
    (lib.cmakeBool "ARROW_USE_SIMD" false)
  ]
  ++ lib.optionals enableS3 [
    (lib.cmakeFeature "AWSSDK_CORE_HEADER_FILE" "${aws-sdk-cpp-arrow}/include/aws/core/Aws.h")
=======
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
    "-DARROW_BUILD_SHARED=${if enableShared then "ON" else "OFF"}"
    "-DARROW_BUILD_STATIC=${if enableShared then "OFF" else "ON"}"
    "-DARROW_BUILD_TESTS=${if enableShared then "ON" else "OFF"}"
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
    "-DARROW_ORC=ON"
    # Parquet options:
    "-DARROW_PARQUET=ON"
    "-DPARQUET_BUILD_EXECUTABLES=ON"
    "-DPARQUET_REQUIRE_ENCRYPTION=ON"
  ]
  ++ lib.optionals (!enableShared) [ "-DARROW_TEST_LINKAGE=static" ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_INSTALL_RPATH=@loader_path/../lib" # needed for tools executables
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [ "-DARROW_USE_SIMD=OFF" ]
  ++ lib.optionals enableS3 [
    "-DAWSSDK_CORE_HEADER_FILE=${aws-sdk-cpp-arrow}/include/aws/core/Aws.h"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          # TODO: revisit at 12.0.0 or when
          # https://github.com/apache/arrow/commit/295c6644ca6b67c95a662410b2c7faea0920c989
          # is available, see
          # https://github.com/apache/arrow/pull/15288#discussion_r1071244661
          "ExecPlanExecution.StressSourceSinkStopped"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        ];
    in
    lib.optionalString finalAttrs.doInstallCheck "-${lib.concatStringsSep ":" filteredTests}";

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    perl
    which
    sqlite
  ]
  ++ lib.optionals enableS3 [ minio ]
<<<<<<< HEAD
  ++ lib.optionals enableFlight [ python3 ]
  ++ lib.optionals enableAzure [ azurite ];
=======
  ++ lib.optionals enableFlight [ python3 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  installCheckPhase =
    let
      disabledTests = [
        # flaky
        "arrow-flight-test"
        # requires networking
        "arrow-gcsfs-test"
        "arrow-flight-integration-test"
        # File already exists in database: orc_proto.proto
        "arrow-orc-adapter-test"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # https://github.com/NixOS/nixpkgs/issues/460687
        # Failing with "run-test.sh: line 88: 63682 Abort trap: 6"
        "arrow-flight-internals-test"
        "arrow-flight-sql-test"
      ];
    in
    ''
      runHook preInstallCheck

      ctest -L unittest --exclude-regex '^(${lib.concatStringsSep "|" disabledTests})$'

      runHook postInstallCheck
    '';

<<<<<<< HEAD
  meta = {
    description = "Cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/docs/cpp/";
    changelog = "https://arrow.apache.org/release/${finalAttrs.version}.html";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/docs/cpp/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
