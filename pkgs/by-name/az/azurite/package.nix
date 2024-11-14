{ lib
, buildNpmPackage
, fetchFromGitHub
, stdenv
, darwin
, libsecret
, pkg-config
, python3
}:

buildNpmPackage rec {
  pname = "azurite";
  version = "3.31.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "Azurite";
    rev = "v${version}";
    hash = "sha256-WT1eprN6SBnsfITCopybEHCuxrHvKEhdmVs7xL3cUi0=";
  };

  npmDepsHash = "sha256-+ptjsz2MDIB/aqu4UxkBLCcehtamFdmswNUsHs23LuE=";

  nativeBuildInputs = [ pkg-config python3 ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libsecret
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin; [
    Security
    apple_sdk.frameworks.AppKit
  ]);

  meta = {
    description = "An open source Azure Storage API compatible server";
    homepage = "https://github.com/Azure/Azurite";
    changelog = "https://github.com/Azure/Azurite/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danielalvsaaker ];
    mainProgram = "azurite";
  };
}
