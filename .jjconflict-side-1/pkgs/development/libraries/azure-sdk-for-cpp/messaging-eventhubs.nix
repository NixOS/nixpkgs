{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  core,
  core-amqp,
  nix-update-script,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-messaging-eventhubs";
  version = "1.0.0-beta.10";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-messaging-eventhubs_1.0.0-beta.10";
    hash = "sha256-qGYfvRFnesI+oIp3jCRo53v66aR2qrcummSNpc5sCOw=";
  };
  sourceRoot = "${finalAttrs.src.name}/sdk/eventhubs/azure-messaging-eventhubs";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [
    core
    core-amqp
  ];

  env = {
    AZURE_SDK_DISABLE_AUTO_VCPKG = 1;
    NIX_CFLAGS_COMPILE = "-Wno-error";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DWARNINGS_AS_ERRORS=OFF"
  ];

  postInstall = ''
    moveToOutput "share" "$dev"
    moveToOutput "share/$(basename "$sourceRoot")-cpp/copyright" "$out"
  '';

  # See note in ./core.nix.
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "azure-messaging-eventhubs_(.*)"
    ];
  };

  meta = (
    meta
    // {
      description = "Azure Event Hubs Client Package for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/eventhubs/azure-messaging-eventhubs/CHANGELOG.md";
    }
  );
})
