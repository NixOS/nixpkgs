{
  stdenv,
  azure-sdk-for-cpp,
  cmake,
  ninja,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-storage-queues";
  version = "12.5.0";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-storage-queues_12.5.0";
    hash = "sha256-u+zaMoX64GcTKE7QIF5WyENTogLBMTCenoI8hPY7m08=";
  };
  sourceRoot = "source/sdk/storage/azure-storage-queues";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [ azure-sdk-for-cpp.storage-common ];

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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "azure-storage-queues_(.*)"
    ];
  };

  meta = (
    azure-sdk-for-cpp.meta
    // {
      description = "Azure Storage Queues Client Library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/storage/azure-storage-queues/CHANGELOG.md";
    }
  );
})
