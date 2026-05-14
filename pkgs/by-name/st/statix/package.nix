{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withJson ? true,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "statix";
  version = "0-unstable-2026-05-09";

  src = fetchFromGitHub {
    owner = "molybdenumsoftware";
    repo = "statix";
    rev = "f61bc82c0c90569de508f0c71a6ba7f4aba9cca7";
    hash = "sha256-4LtWT+BFSPaq5DXQPlZ+xVrW/osS9yhG5T0tEfSdczs=";
  };

  cargoHash = "sha256-lODAnIGw8MncMT5xicWORSbCChn2HQXENsOStJYHepQ=";

  buildFeatures = lib.optional withJson "json";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/molybdenumsoftware/statix";
    license = lib.licenses.mit;
    mainProgram = "statix";
    maintainers = with lib.maintainers; [
      mightyiam
      nerdypepper
      progrm_jarvis
    ];
  };
})
