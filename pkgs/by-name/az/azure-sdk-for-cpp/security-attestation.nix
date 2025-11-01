{
  stdenv,
  fetchFromGitHub,
  azure-sdk-for-cpp,
  cmake,
  ninja,
  openssl,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-security-attestation";
  version = "1.2.0-beta.1-unreleased-2025-03-12";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-security-attestation_1.1.0";
    hash = "sha256-RXCMB7MMIe5x5YgMAqAf306E/1vuRXweAlN5uDHumjA=";
  };
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

  buildInputs = [ openssl ];
  propagatedBuildInputs = [ azure-sdk-for-cpp.core ];

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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "azure-security-attestation_(.*)"
    ];
  };

  doCheck = false;

  meta = (
    azure-sdk-for-cpp.meta
    // {
      description = "Azure Attestation Package client library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/attestation/azure-security-attestation/CHANGELOG.md";
    }
  );
})
