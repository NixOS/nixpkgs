{
  stdenv,
  fetchFromGitHub,
  azure-sdk-for-cpp,
  cmake,
  ninja,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-keyvault-administration";
  version = "4.0.0-beta.5";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-security-keyvault-administration_4.0.0-beta.5";
    hash = "sha256-EaiJ2Q6c1VsL+RRF0MvS8jdcHwrKLeTJ0fBlySFt/+w=";
  };
  sourceRoot = "source/sdk/keyvault/azure-security-keyvault-administration";

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
      "azure-security-keyvault-administration_(.*)"
    ];
  };

  meta = (
    azure-sdk-for-cpp.meta
    // {
      description = "Azure Security KeyVault Administration client library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/keyvault/azure-security-keyvault-administration/CHANGELOG.md";
    }
  );
})
