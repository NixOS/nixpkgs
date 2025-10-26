{
  stdenv,
  azure-sdk-for-cpp,
  cmake,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-messaging-eventhubs";
  version = "1.0.0-beta.11-unreleased-2025-05-21";
  outputs = [
    "out"
    "dev"
  ];

  inherit (azure-sdk-for-cpp) meta src;
  sourceRoot = "source/sdk/eventhubs/azure-messaging-eventhubs";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [
    azure-sdk-for-cpp.core
    azure-sdk-for-cpp.core-amqp
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
    moveToOutput "share" $dev
  '';

  doCheck = false;
})
