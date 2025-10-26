{
  stdenv,
  azure-sdk-for-cpp,
  cmake,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-storage-files-datalake";
  version = "12.13.0-beta.2-unreleased-2025-06-25";
  outputs = [
    "out"
    "dev"
  ];

  inherit (azure-sdk-for-cpp) meta src;
  sourceRoot = "source/sdk/storage/azure-storage-files-datalake";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [
    azure-sdk-for-cpp.storage-blobs
    azure-sdk-for-cpp.storage-common
  ];

  env = {
    AZURE_SDK_DISABLE_AUTO_VCPKG = 1;
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
