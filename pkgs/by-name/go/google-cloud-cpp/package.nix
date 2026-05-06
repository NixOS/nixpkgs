{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  abseil-cpp,
  c-ares,
  cmake,
  crc32c,
  curl,
  gbenchmark,
  grpc,
  gtest,
  ninja,
  nlohmann_json,
  openssl,
  opentelemetry-cpp,
  pkg-config,
  protobuf,
  pkgsBuildHost,
  # default list of APIs: https://github.com/googleapis/google-cloud-cpp/blob/v3.2.0/cmake/GoogleCloudCppFeatures.cmake#L24
  apis ? [ "*" ],
  staticOnly ? stdenv.hostPlatform.isStatic,
}:
let
  # defined in cmake/GoogleapisConfig.cmake
  googleapisRev = "edfe7983b9d99d6244b4d7636d25fa6e752a2041";
  googleapis = fetchFromGitHub {
    name = "googleapis-src";
    owner = "googleapis";
    repo = "googleapis";
    rev = googleapisRev;
    hash = "sha256-Rs/MM+lR9yiHcQcsk8kvz/Vkav7IaunYEGAKc+gCQe4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "google-cloud-cpp";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9aAqAiEr4AqN7J4UYlCw9LbKmaHa/Eoslh+mxhiCb78=";
  };

  patches = [
    (replaceVars ./hardcode-googleapis-path.patch {
      url = googleapis;
    })
  ];

  # We add the missing `<algorithm>` header to fix "error: 'transform' is not a
  # member of 'std'"
  postPatch = ''
    sed -e '1i #include <algorithm>' -i google/cloud/testing_util/command_line_parsing.cc
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    c-ares
    gbenchmark
  ];

  propagatedBuildInputs = [
    abseil-cpp
    crc32c
    (curl.override { inherit openssl; })
    grpc
    gtest
    nlohmann_json
    openssl
    opentelemetry-cpp
    protobuf
  ];

  doInstallCheck = true;

  preInstallCheck =
    let
      # These paths are added to (DY)LD_LIBRARY_PATH because they contain
      # testing-only shared libraries that do not need to be installed, but
      # need to be loadable by the test executables.
      #
      # Setting (DY)LD_LIBRARY_PATH is only necessary when building shared libraries.
      additionalLibraryPaths = [
        "$PWD/google/cloud/bigtable"
        "$PWD/google/cloud/bigtable/benchmarks"
        "$PWD/google/cloud/pubsub"
        "$PWD/google/cloud/spanner"
        "$PWD/google/cloud/spanner/benchmarks"
        "$PWD/google/cloud/storage"
        "$PWD/google/cloud/storage/benchmarks"
        "$PWD/google/cloud/testing_util"
      ];
      ldLibraryPathName = "${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH";
    in
    lib.optionalString finalAttrs.doInstallCheck (
      lib.optionalString (!staticOnly) ''
        export ${ldLibraryPathName}=${lib.concatStringsSep ":" additionalLibraryPaths}
      ''
    );

  installCheckPhase =
    let
      disabledTests = ''
        bigtable_internal_data_connection_impl_test
      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        common_internal_async_connection_ready_test
        bigtable_async_read_stream_test
        bigtable_metadata_update_policy_test
        bigtable_bigtable_benchmark_test
        bigtable_embedded_server_test
      '';
    in
    ''
      runHook preInstallCheck

      # Disable any integration tests, which need to contact the internet.
      ctest \
        --label-exclude integration-test \
        --exclude-from-file <(echo '${disabledTests}')

      runHook postInstallCheck
    '';

  nativeInstallCheckInputs = lib.optionals finalAttrs.doInstallCheck [
    gbenchmark
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!staticOnly))
    # unconditionally build tests to catch linker errors as early as possible
    # this adds a good chunk of time to the build
    (lib.cmakeBool "BUILD_TESTING" true)

    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "20")

    (lib.cmakeBool "GOOGLE_CLOUD_CPP_ENABLE_EXAMPLES" false)

    # Explicitly set this variable to true as otherwise `universe_domain` will be filtered out
    # See https://github.com/googleapis/google-cloud-cpp/pull/15820 for context
    (lib.cmakeBool "GOOGLE_CLOUD_CPP_ENABLE_UNIVERSE_DOMAIN" true)
  ]
  ++ lib.optionals (apis != [ "*" ]) [
    (lib.cmakeFeature "GOOGLE_CLOUD_CPP_ENABLE" (lib.concatStringsSep ";" apis))
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    (lib.cmakeFeature "GOOGLE_CLOUD_CPP_GRPC_PLUGIN_EXECUTABLE" "${lib.getBin pkgsBuildHost.grpc}/bin/grpc_cpp_plugin")
  ];

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/googleapis/google-cloud-cpp";
    description = "C++ Idiomatic Clients for Google Cloud Platform services";
    changelog = "https://github.com/googleapis/google-cloud-cpp/blob/v${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
})
