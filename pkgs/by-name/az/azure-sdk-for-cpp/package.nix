{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  callPackage,
  ninja,
  pkg-config,
  curl,
  apple-sdk,
  openssl,
}:
let
  macro-utils-c = stdenv.mkDerivation {
    # Same version as in VCPKG as of February 2025.
    # https://github.com/microsoft/vcpkg/blob/master/ports/azure-macro-utils-c/portfile.cmake
    pname = "azure-macro-utils-c";
    version = "unstable-2022-01-21";

    src = fetchFromGitHub {
      owner = "Azure";
      repo = "macro-utils-c";
      rev = "5926caf4e42e98e730e6d03395788205649a3ada";
      hash = "sha256-K5G+g+Jnzf7qfb/4+rVOpVgSosoEtNV3Joct1y1Xcdw=";
    };

    nativeBuildInputs = [ cmake ];

    meta = {
      homepage = "https://github.com/Azure/macro-utils-c";
      description = "A C header file that contains a multitude of very useful C macros";
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.tobim ];
      platforms = lib.platforms.all;
    };
  };

  c-shared-utility = stdenv.mkDerivation {
    pname = "azure-c-shared-utility";
    # Same version as in VCPKG as of February 2025.
    # https://github.com/microsoft/vcpkg/blob/master/ports/azure-c-shared-utility/portfile.cmake
    version = "unstable-2024-06-24";

    src = fetchFromGitHub {
      owner = "Azure";
      repo = "azure-c-shared-utility";
      rev = "51d6f3f7246876051f713c7abed28f909bf604e3";
      hash = "sha256-YT6rkIf5xGbV52UkGcRv/zyYj6thF7XBZU+Qovt1C6Q=";
    };

    # Using the cmake target instead of the variable correctly propagates
    # transitive dependencies when using static libraries.
    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "\''${CURL_LIBRARIES}" "CURL::libcurl"
    '';

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
    ];
    buildInputs = [
      macro-utils-c
      umock-c
    ] ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk;
    propagatedBuildInputs = [ curl ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) openssl;

    cmakeFlags = [
      "-Duse_default_uuid=ON"
      "-Duse_installed_dependencies=ON"
    ];

    postInstall = ''
      mkdir $out/include/azureiot
    '';

    meta = {
      homepage = "https://github.com/Azure/azure-c-shared-utility";
      description = "Azure C SDKs common code";
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.tobim ];
      platforms = lib.platforms.all;
    };
  };

  umock-c = stdenv.mkDerivation {
    pname = "azure-sdk-for-cpp";
    # Same version as in VCPKG as of February 2025.
    # https://github.com/microsoft/vcpkg/blob/master/ports/umock-c/portfile.cmake
    version = "unstable-2022-01-21";

    src = fetchFromGitHub {
      owner = "Azure";
      repo = "umock-c";
      rev = "504193e65d1c2f6eb50c15357167600a296df7ff";
      hash = "sha256-oeqsy63G98c4HWT6NtsYzC6/YxgdROvUe9RAdmElbCM=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];
    buildInputs = [ macro-utils-c ];

    cmakeFlags = [ "-Duse_installed_dependencies=ON" ];

    meta = {
      homepage = "https://github.com/Azure/umock-c";
      description = " A pure C mocking library";
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.tobim ];
      platforms = lib.platforms.all;
    };
  };

  attestation = callPackage ./attestation.nix { };
  core = callPackage ./core.nix { };
  core-amqp = callPackage ./core-amqp.nix { };
  core-tracing-opentelemetry = callPackage ./core-tracing-opentelemetry.nix { };
  messaging-eventhubs = callPackage ./messaging-eventhubs.nix { };
  messaging-eventhubs-checkpointstore-blob =
    callPackage ./messaging-eventhubs-checkpointstore-blob.nix
      { };
  identity = callPackage ./identity.nix { };
  keyvault-administration = callPackage ./keyvault-administration.nix { };
  keyvault-certificates = callPackage ./keyvault-certificates.nix { };
  keyvault-keys = callPackage ./keyvault-keys.nix { };
  keyvault-secrets = callPackage ./keyvault-secrets.nix { };
  storage-blobs = callPackage ./storage-blobs.nix { };
  storage-common = callPackage ./storage-common.nix { };
  storage-files-datalake = callPackage ./storage-files-datalake.nix { };
  storage-files-shares = callPackage ./storage-files-shares.nix { };
  storage-queues = callPackage ./storage-queues.nix { };
  tables = callPackage ./tables.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-identity_1.10.0";
    hash = "sha256-3CDC/DF7spIpLavcz3nsdBXperm9yMidrFRgb8+rwnU=";
  };

  propagatedBuildInputs = [
    attestation
    core
    core-amqp
    # Currently broken, see comment in ./core-tracing-opentelemetry.nix.
    #core-tracing-opentelemetry
    messaging-eventhubs
    messaging-eventhubs-checkpointstore-blob
    identity
    keyvault-administration
    keyvault-certificates
    keyvault-keys
    keyvault-secrets
    storage-blobs
    storage-common
    storage-files-datalake
    storage-files-shares
    storage-queues
    tables
  ];

  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir $out
    runHook postInstall
  '';

  passthru = {
    inherit
      c-shared-utility
      macro-utils-c
      umock-c
      attestation
      core
      core-amqp
      core-tracing-opentelemetry
      messaging-eventhubs
      messaging-eventhubs-checkpointstore-blob
      identity
      keyvault-administration
      keyvault-certificates
      keyvault-keys
      keyvault-secrets
      storage-blobs
      storage-common
      storage-files-datalake
      storage-files-shares
      storage-queues
      tables
      ;
  };

  meta = {
    homepage = "https://azure.github.io/azure-sdk-for-cpp";
    description = "Next generation multi-platform command line experience for Azure";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tobim ];
    platforms = lib.platforms.unix;
  };
})
