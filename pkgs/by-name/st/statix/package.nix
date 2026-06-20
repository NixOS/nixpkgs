{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withJson ? true,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "statix";
  version = "0.5.8-unstable-2026-06-13";

  src = fetchFromGitHub {
    owner = "molybdenumsoftware";
    repo = "statix";
    rev = "127a42f761909e5caa79f616a353e9b6e1a0587f";
    hash = "sha256-epwk3oW5A0ttTKSO2zgC50PkD9mTFjLtDlofTIeOdf8=";
  };

  cargoHash = "sha256-bsy8p8zbfQ7EjXCDwFbVaq4qN8aEsp27Jcn9zfW2eXw=";

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
