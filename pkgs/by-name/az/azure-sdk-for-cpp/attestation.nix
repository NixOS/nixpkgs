{
  stdenv,
  azure-sdk-for-cpp,
  cmake,
  ninja,
  openssl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-security-attestation";
  version = "1.1.0";
  outputs = [
    "out"
    "dev"
  ];

  inherit (azure-sdk-for-cpp) meta src;
  sourceRoot = "source/sdk/attestation/azure-security-attestation";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
    substituteInPlace src/private/crypto/openssl/openssl_helpers.hpp \
      --replace-fail "#ifdef __cpp_nontype_template_parameter_auto" "#if 0"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    openssl
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
