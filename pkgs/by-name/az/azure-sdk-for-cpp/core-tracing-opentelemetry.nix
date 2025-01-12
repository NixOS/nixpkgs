{
  stdenv,
  azure-sdk-for-cpp,
  cmake,
  ninja,
  opentelemetry-cpp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-core-tracing-opentelemetry";
  version = "1.14.0";
  outputs = [
    "out"
    "dev"
  ];

  inherit (azure-sdk-for-cpp) src;
  sourceRoot = "source/sdk/core/azure-core-tracing-opentelemetry";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    opentelemetry-cpp
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

  meta = azure-sdk-for-cpp.meta // {
    # Needs https://github.com/open-telemetry/opentelemetry-cpp/pull/3094.
    broken = true;
  };
})
