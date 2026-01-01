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
<<<<<<< HEAD
  protobuf,
  pkgsBuildHost,
  # default list of APIs: https://github.com/googleapis/google-cloud-cpp/blob/v2.44.0/cmake/GoogleCloudCppFeatures.cmake#L24
=======
  protobuf_31,
  pkgsBuildHost,
  # default list of APIs: https://github.com/googleapis/google-cloud-cpp/blob/v1.32.1/CMakeLists.txt#L173
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  apis ? [ "*" ],
  staticOnly ? stdenv.hostPlatform.isStatic,
}:
let
  # defined in cmake/GoogleapisConfig.cmake
<<<<<<< HEAD
  googleapisRev = "8cd3749f4b98f2eeeef511c16431979aeb3a6502";
=======
  googleapisRev = "f01a17a560b4fbc888fd552c978f4e1f8614100b";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  googleapis = fetchFromGitHub {
    name = "googleapis-src";
    owner = "googleapis";
    repo = "googleapis";
    rev = googleapisRev;
<<<<<<< HEAD
    hash = "sha256-w7jq21qLEiMhuI20C6iUeSskAfZCkZgDCPu5Flr8D48=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "google-cloud-cpp";
  version = "2.44.0";
=======
    hash = "sha256-eJA3KM/CZMKTR3l6omPJkxqIBt75mSNsxHnoC+1T4gw=";
  };
in
stdenv.mkDerivation rec {
  pname = "google-cloud-cpp";
  version = "2.38.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-cpp";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-vE3oGGT33cITdAd4e5Xnlx9tX5Sz+wIFQXzj5hdcGDI=";
=======
    rev = "v${version}";
    sha256 = "sha256-TF3MLBmjUbKJkZVcaPXbagXrAs3eEhlNQBjYQf0VtT8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    (replaceVars ./hardcode-googleapis-path.patch {
      url = googleapis;
    })
  ];

<<<<<<< HEAD
  # After 30acc3c, the configPhase fails with:
  # Target "spanner_database_admin_client_samples" links to:
  #   google-cloud-cpp::universe_domain
  # but the target was not found.
  #
  # So, we explicitly add `universe_domain` to the list of default features
  postPatch = ''
    substituteInPlace cmake/GoogleCloudCppFeatures.cmake \
      --replace-fail \
        "bigtable;bigquery;iam;logging;pubsub;spanner;storage" \
        "bigtable;bigquery;iam;logging;pubsub;spanner;storage;universe_domain" \
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    protobuf
=======
    protobuf_31
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    lib.optionalString finalAttrs.doInstallCheck (
=======
    lib.optionalString doInstallCheck (
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  nativeInstallCheckInputs = lib.optionals finalAttrs.doInstallCheck [
=======
  nativeInstallCheckInputs = lib.optionals doInstallCheck [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    gbenchmark
    gtest
  ];

  cmakeFlags = [
<<<<<<< HEAD
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!staticOnly))
    # unconditionally build tests to catch linker errors as early as possible
    # this adds a good chunk of time to the build
    (lib.cmakeBool "BUILD_TESTING" true)
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  requiredSystemFeatures = [ "big-parallel" ];

<<<<<<< HEAD
  meta = {
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/googleapis/google-cloud-cpp";
    description = "C++ Idiomatic Clients for Google Cloud Platform services";
    changelog = "https://github.com/googleapis/google-cloud-cpp/blob/v${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
})
=======
  meta = with lib; {
    license = with licenses; [ asl20 ];
    homepage = "https://github.com/googleapis/google-cloud-cpp";
    description = "C++ Idiomatic Clients for Google Cloud Platform services";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with maintainers; [ cpcloud ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
