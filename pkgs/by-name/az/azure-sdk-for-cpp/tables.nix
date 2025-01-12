{
  stdenv,
  azure-sdk-for-cpp,
  cmake,
  ninja,
  openssl,
  libxml2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-tables";
  version = "1.0.0-beta.5";
  outputs = [
    "out"
    "dev"
  ];

  inherit (azure-sdk-for-cpp) meta src;
  sourceRoot = "source/sdk/tables/azure-data-tables";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    openssl
    libxml2
  ];
  propagatedBuildInputs = [
    azure-sdk-for-cpp.core
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
