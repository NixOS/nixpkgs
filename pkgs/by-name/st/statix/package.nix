{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withJson ? true,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "statix";
  version = "0-unstable-2026-05-14";

  src = fetchFromGitHub {
    owner = "molybdenumsoftware";
    repo = "statix";
    rev = "f0d256d60d9b9736b274a0edc0492be472318166";
    hash = "sha256-dylteN19qQ/MclInQ+x4vf+rBGNIsaKWJ+WgiS0ZBjI=";
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
