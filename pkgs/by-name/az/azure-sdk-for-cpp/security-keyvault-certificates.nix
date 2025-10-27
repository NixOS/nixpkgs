{
  stdenv,
  fetchFromGitHub,
  azure-sdk-for-cpp,
  cmake,
  ninja,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-security-keyvault-certificates";
  version = "4.3.0-beta.4";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-security-keyvault-certificates_4.3.0-beta.4";
    hash = "sha256-6LvqeSqSz5oDxXoR/vD7Pbxc2ksQflFhIrN7DzmMoaE=";
  };
  sourceRoot = "source/sdk/keyvault/azure-security-keyvault-certificates";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

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

  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "azure-security-keyvault-certificates_(.*)"
    ];
  };

  meta = (
    azure-sdk-for-cpp.meta
    // {
      description = "Azure Key Vault Certificates client library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/keyvault/azure-security-keyvault-certificates/CHANGELOG.md";
    }
  );
})
