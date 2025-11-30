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
  protobuf_31,
  pkgsBuildHost,
  # default list of APIs: https://github.com/googleapis/google-cloud-cpp/blob/v1.32.1/CMakeLists.txt#L173
  apis ? [ "*" ],
  staticOnly ? stdenv.hostPlatform.isStatic,
}:
let
  # defined in cmake/GoogleapisConfig.cmake
  googleapisRev = "f01a17a560b4fbc888fd552c978f4e1f8614100b";
  googleapis = fetchFromGitHub {
    name = "googleapis-src";
    owner = "googleapis";
    repo = "googleapis";
    rev = googleapisRev;
    hash = "sha256-eJA3KM/CZMKTR3l6omPJkxqIBt75mSNsxHnoC+1T4gw=";
  };
in
stdenv.mkDerivation rec {
  pname = "google-cloud-cpp";
  version = "2.38.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-cpp";
    rev = "v${version}";
    sha256 = "sha256-TF3MLBmjUbKJkZVcaPXbagXrAs3eEhlNQBjYQf0VtT8=";
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
    protobuf_31
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
    lib.optionalString doInstallCheck (
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

  nativeInstallCheckInputs = lib.optionals doInstallCheck [
    gbenchmark
    gtest
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=${if staticOnly then "OFF" else "ON"}"
    # unconditionally build tests to catch linker errors as early as possible
    # this adds a good chunk of time to the build
    "-DBUILD_TESTING:BOOL=ON"
    "-DGOOGLE_CLOUD_CPP_ENABLE_EXAMPLES:BOOL=OFF"
  ]
  ++ lib.optionals (apis != [ "*" ]) [
    "-DGOOGLE_CLOUD_CPP_ENABLE=${lib.concatStringsSep ";" apis}"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-DGOOGLE_CLOUD_CPP_GRPC_PLUGIN_EXECUTABLE=${lib.getBin pkgsBuildHost.grpc}/bin/grpc_cpp_plugin"
  ];

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    license = with licenses; [ asl20 ];
    homepage = "https://github.com/googleapis/google-cloud-cpp";
    description = "C++ Idiomatic Clients for Google Cloud Platform services";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with maintainers; [ cpcloud ];
  };
}
