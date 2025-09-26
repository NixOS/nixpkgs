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
  version = "3.35.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "Azurite";
    rev = "v${version}";
    hash = "sha256-sVYiHQJ3nR5vM+oPAHzr/MjuNBMY14afqCHpw32WCiQ=";
  };

  npmDepsHash = "sha256-UBHjb65Ud7IANsR30DokbI/16+dVjDEtfhqRPAQhGUw=";

  nativeBuildInputs = [
    pkg-config
    python3
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libsecret
  ];

  meta = {
    description = "Open source Azure Storage API compatible server";
    homepage = "https://github.com/Azure/Azurite";
    changelog = "https://github.com/Azure/Azurite/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danielalvsaaker ];
    mainProgram = "azurite";
  };
}
