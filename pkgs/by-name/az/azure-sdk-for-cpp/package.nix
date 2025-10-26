{
  lib,
  stdenv,
  runCommand,
  fetchFromGitHub,
  newScope,
  cmake,
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
    version = "1.1.0-unstable-2022-01-21";

    src = fetchFromGitHub {
      owner = "Azure";
      repo = "macro-utils-c";
      rev = "5926caf4e42e98e730e6d03395788205649a3ada";
      hash = "sha256-K5G+g+Jnzf7qfb/4+rVOpVgSosoEtNV3Joct1y1Xcdw=";
    };

    nativeBuildInputs = [ cmake ];

    cmakeFlags = [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];

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
    # Same version as in VCPKG as of July 2025.
    # https://github.com/microsoft/vcpkg/blob/master/ports/azure-c-shared-utility/portfile.cmake
    version = "LTS_07_2022_Ref02-unstable-2025-03-31";

    src = fetchFromGitHub {
      owner = "Azure";
      repo = "azure-c-shared-utility";
      rev = "772a4f8bc338140b4a0f404cf9c344283c5c937f";
      hash = "sha256-NSgY7EQhqR01s00mwgLJFMi8salbsCoAG2PMFrONBGk=";
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
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk;
    propagatedBuildInputs = [ curl ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) openssl;

    cmakeFlags = [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      "-Duse_default_uuid=ON"
      "-Duse_installed_dependencies=ON"
    ];

    env = {
      NIX_CFLAGS_COMPILE = "-Wno-error";
    };

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
    pname = "azure-umock-c";
    # Same version as in VCPKG as of February 2025.
    # https://github.com/microsoft/vcpkg/blob/master/ports/umock-c/portfile.cmake
    version = "1.1.0-unstable-2022-01-21";

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

    cmakeFlags = [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      "-Duse_installed_dependencies=ON"
    ];

    meta = {
      homepage = "https://github.com/Azure/umock-c";
      description = " A pure C mocking library";
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.tobim ];
      platforms = lib.platforms.all;
    };
  };

  scope = lib.makeScope newScope (
    self:
    let
      callPackage = self.callPackage;
    in
    {
      inherit
        stdenv
        cmake
        ninja
        pkg-config
        curl
        apple-sdk
        openssl
        ;
      core = callPackage ./core.nix { };
      core-amqp = callPackage ./core-amqp.nix { };
      core-tracing-opentelemetry = callPackage ./core-tracing-opentelemetry.nix { };
      data-tables = callPackage ./data-tables.nix { };
      identity = callPackage ./identity.nix { };
      messaging-eventhubs = callPackage ./messaging-eventhubs.nix { };
      messaging-eventhubs-checkpointstore-blob =
        callPackage ./messaging-eventhubs-checkpointstore-blob.nix
          { };
      security-attestation = callPackage ./security-attestation.nix { };
      security-keyvault-administration = callPackage ./security-keyvault-administration.nix { };
      security-keyvault-certificates = callPackage ./security-keyvault-certificates.nix { };
      security-keyvault-keys = callPackage ./security-keyvault-keys.nix { };
      security-keyvault-secrets = callPackage ./security-keyvault-secrets.nix { };
      storage-blobs = callPackage ./storage-blobs.nix { };
      storage-common = callPackage ./storage-common.nix { };
      storage-files-datalake = callPackage ./storage-files-datalake.nix { };
      storage-files-shares = callPackage ./storage-files-shares.nix { };
      storage-queues = callPackage ./storage-queues.nix { };
    }
  );
in
runCommand "azure-sdk-for-cpp"
  {
    propagatedBuildInputs = [
      scope.core
      scope.core-amqp
      scope.core-tracing-opentelemetry
      scope.data-tables
      scope.identity
      scope.messaging-eventhubs
      scope.messaging-eventhubs-checkpointstore-blob
      scope.security-attestation
      scope.security-keyvault-administration
      scope.security-keyvault-certificates
      scope.security-keyvault-keys
      scope.security-keyvault-secrets
      scope.storage-blobs
      scope.storage-common
      scope.storage-files-datalake
      scope.storage-files-shares
      scope.storage-queues
    ];

    passthru = {
      inherit
        c-shared-utility
        macro-utils-c
        umock-c
        ;
      inherit (scope)
        core
        core-amqp
        core-tracing-opentelemetry
        data-tables
        identity
        messaging-eventhubs
        messaging-eventhubs-checkpointstore-blob
        security-attestation
        security-keyvault-administration
        security-keyvault-certificates
        security-keyvault-keys
        security-keyvault-secrets
        storage-blobs
        storage-common
        storage-files-datalake
        storage-files-shares
        storage-queues
        ;
    };

    meta = {
      homepage = "https://azure.github.io/azure-sdk-for-cpp";
      description = "Azure SDK for C++";
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.tobim ];
      platforms = lib.platforms.all;
    };
  }

  ''
    mkdir $out
  ''
