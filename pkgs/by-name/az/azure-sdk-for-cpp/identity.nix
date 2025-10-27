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
  pname = "azure-sdk-for-cpp-identity";
  version = "1.13.2";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-identity_1.13.2";
    hash = "sha256-864fU7BkVWXE0vVEYniXQUbrNRvLhhv6aR3wwdnjbQo=";
  };
  sourceRoot = "source/sdk/identity/azure-identity";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
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

  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "azure-identity_(.*)"
    ];
  };

  meta = (
    azure-sdk-for-cpp.meta
    // {
      description = "Azure Identity client library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/identity/azure-identity/CHANGELOG.md";
    }
  );
})
