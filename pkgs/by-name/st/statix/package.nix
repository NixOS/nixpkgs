{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withJson ? true,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "statix";
  version = "0.5.8-unstable-2026-06-22";

  src = fetchFromGitHub {
    owner = "molybdenumsoftware";
    repo = "statix";
    rev = "5d23643fcb0aea7372f7b598b3edb3e2bd8adf83";
    hash = "sha256-woMMDcjiFgcbRt3Ywb5cOPv2P8S4+NqC6W6i8q1j4rU=";
  };

  cargoHash = "sha256-p3A88MMt3GkcC1shCNC8DmiXQCMXrWd+hA36D7VRZOE=";

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
