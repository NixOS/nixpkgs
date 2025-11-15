{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
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
  pkg-config,
  protobuf,
  pkgsBuildHost,
  # default list of APIs: https://github.com/googleapis/google-cloud-cpp/blob/v2.43.0/cmake/GoogleCloudCppFeatures.cmake#L24
  apis ? [ "*" ],
  staticOnly ? stdenv.hostPlatform.isStatic,
}:
let
  # defined in cmake/GoogleapisConfig.cmake
  googleapisRev = "2193a2bfcecb92b92aad7a4d81baa428cafd7dfd";
  googleapis = fetchFromGitHub {
    name = "googleapis-src";
    owner = "googleapis";
    repo = "googleapis";
    rev = googleapisRev;
    hash = "sha256-M+3ywDd1kyo6U/9o7fpsqYIPuulf8fDe3a4mjJKEN2U=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "google-cloud-cpp";
  version = "2.43.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2OnzObCTmB6E4Ut0blmL7CRAJJ9EKl6eSVdfuPS4B2Y=";
  };

  patches = [
    (replaceVars ./hardcode-googleapis-path.patch {
      url = googleapis;
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    c-ares
    crc32c
    (curl.override { inherit openssl; })
    grpc
    nlohmann_json
    openssl
    protobuf
    gbenchmark
    gtest
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
      disabledTests = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
    (lib.cmakeBool "GOOGLE_CLOUD_CPP_ENABLE_EXAMPLES" false)
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
