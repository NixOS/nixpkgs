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
  azure-sdk-for-cpp,
  azurite,
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
  enableFlight ? stdenv.buildPlatform == stdenv.hostPlatform,
  # Disable also on RiscV
  # configure: error: cannot determine number of significant virtual address bits
  enableJemalloc ?
    !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isRiscV64,
  enableS3 ? true,
  # google-cloud-cpp fails to build on RiscV
  enableGcs ? !stdenv.hostPlatform.isRiscV64,
  enableAzure ? true,
}:

let
  arrow-testing = fetchFromGitHub {
    name = "arrow-testing";
    owner = "apache";
    repo = "arrow-testing";
    rev = "9a02925d1ba80bd493b6d4da6e8a777588d57ac4";
    hash = "sha256-dEFCkeQpQrU61uCwJp/XB2umbQHjXtzado36BGChoc0=";
  };

  parquet-testing = fetchFromGitHub {
    name = "parquet-testing";
    owner = "apache";
    repo = "parquet-testing";
    rev = "a3d96a65e11e2bbca7d22a894e8313ede90a33a3";
    hash = "sha256-Xd6o3RT6Q0tPutV77J0P1x3F6U3RHdCBOKGUKtkQCKk=";
  };

  version = "22.0.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "arrow-cpp";
  inherit version;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow";
    rev = "apache-arrow-${version}";
    hash = "sha256-i4Smt43oi4sddUt3qH7ePjensBSfPW+w/ExLVcVNKic=";
  };

  sourceRoot = "${finalAttrs.src.name}/cpp";

  # versions are all taken from
  # https://github.com/apache/arrow/blob/apache-arrow-${version}/cpp/thirdparty/versions.txt

  env =
    lib.optionalAttrs enableJemalloc {
      # jemalloc: arrow uses a custom prefix to prevent default allocator symbol
      # collisions as well as custom build flags
      ARROW_JEMALLOC_URL = fetchurl {
        url = "https://github.com/jemalloc/jemalloc/releases/download/5.3.0/jemalloc-5.3.0.tar.bz2";
        hash = "sha256-LbgtHnEZ3z5xt2QCGbbf6EeJvAU3mDw7esT3GJrs/qo=";
      };
    }
    // {
      # mimalloc: arrow uses custom build flags for mimalloc
      ARROW_MIMALLOC_URL = fetchFromGitHub {
        owner = "microsoft";
        repo = "mimalloc";
        tag = "v3.1.5";
        hash = "sha256-fk6nfyBFS1G0sJwUJVgTC1+aKd0We/JjsIYTO+IOfyg=";
      };

      ARROW_XSIMD_URL = fetchFromGitHub {
        owner = "xtensor-stack";
        repo = "xsimd";
        tag = "13.0.0";
        hash = "sha256-qElJYW5QDj3s59L3NgZj5zkhnUMzIP2mBa1sPks3/CE=";
      };

      ARROW_SUBSTRAIT_URL = fetchFromGitHub {
        owner = "substrait-io";
        repo = "substrait";
        tag = "v0.44.0";
        hash = "sha256-V739IFTGPtbGPlxcOi8sAaYSDhNUEpITvN9IqdPReug=";
      };

      # apache-orc looks for things in caps
      LZ4_ROOT = lz4;
      ZSTD_ROOT = zstd.dev;
    }
    // lib.optionalAttrs finalAttrs.doInstallCheck {
      ARROW_TEST_DATA = "${arrow-testing}/data";
      PARQUET_TEST_DATA = "${parquet-testing}/data";
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
            ];
        in
        "-${lib.concatStringsSep ":" filteredTests}";
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
    curl
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
    google-cloud-cpp
    grpc
    nlohmann_json
  ]
  ++ lib.optionals enableAzure [
    azure-sdk-for-cpp.identity
    azure-sdk-for-cpp.storage-blobs
    azure-sdk-for-cpp.storage-files-datalake
  ];

  # fails tests on glibc with this enabled
  hardeningDisable = [ "glibcxxassertions" ];

  preConfigure = ''
    patchShebangs build-support/
    substituteInPlace "src/arrow/vendored/datetime/tz.cpp" \
      --replace-fail 'discover_tz_dir();' '"${tzdata}/share/zoneinfo";'
  '';

  cmakeFlags = [
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
  ];

  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    perl
    which
    sqlite
  ]
  ++ lib.optionals enableS3 [ minio ]
  ++ lib.optionals enableFlight [ python3 ]
  ++ lib.optionals enableAzure [ azurite ];

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
      ]
      ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
        # https://github.com/apache/arrow/issues/41505
        "TestAzuriteGeneric.Empty"
      ];
    in
    ''
      runHook preInstallCheck

      ctest -L unittest --exclude-regex '^(${lib.concatStringsSep "|" disabledTests})$'

      runHook postInstallCheck
    '';

  meta = {
    description = "Cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/docs/cpp/";
    changelog = "https://arrow.apache.org/release/${finalAttrs.version}.html";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
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
