{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withJson ? true,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "statix";
  version = "0.5.8-unstable-2026-07-10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "molybdenumsoftware";
    repo = "statix";
    rev = "7cbd82249a0154836db6118bec97da06ab447013";
    hash = "sha256-3n3hDc52+hAj1TWr3TFAeWzyDkaprsHafZVAlcS2WAM=";
  };

  cargoHash = "sha256-Ed0eSGhx0D1oZS44ObS3j1TuM3A1HnDKzDjDVYlX1jM=";

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
