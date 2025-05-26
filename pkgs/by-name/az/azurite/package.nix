{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  libsecret,
  pkg-config,
  python3,
}:

buildNpmPackage rec {
  pname = "azurite";
  version = "3.34.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "Azurite";
    rev = "v${version}";
    hash = "sha256-6NECduq2ewed8bR4rlF5MW8mGcsgu8bqgA/DBt8ywtM=";
  };

  npmDepsHash = "sha256-WRaD99CsIuH3BrO01eVuoEZo40VjuScnVzmlFcKpj8g=";

  nativeBuildInputs = [
    pkg-config
    python3
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libsecret
  ];

  meta = {
    description = "An open source Azure Storage API compatible server";
    homepage = "https://github.com/Azure/Azurite";
    changelog = "https://github.com/Azure/Azurite/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danielalvsaaker ];
    mainProgram = "azurite";
  };
}
