{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withJson ? true,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "statix";
  version = "0-unstable-2026-05-03";

  src = fetchFromGitHub {
    owner = "molybdenumsoftware";
    repo = "statix";
    rev = "91e28aa76179b5769e8eff7ff4b09464d0913f27";
    hash = "sha256-JDCJ8fgIs5ZdYygQxlR63H/V4VyfmVMR4FleWwAl+AM=";
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
