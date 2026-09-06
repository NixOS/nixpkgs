{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-graph";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "git-bahn";
    repo = "git-graph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5h1PSVGLxWVktRNPbVbx/Rk3/URcIMJvDCbG0PTtBk0=";
  };

  cargoHash = "sha256-MGa9QKCEu7t3y7AKAm++/8+C+PjAY1dFAFIxpr4c9ks=";

  meta = {
    description = "Command line tool to show clear git graphs arranged for your branching model";
    homepage = "https://github.com/git-bahn/git-graph";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cafkafk
      matthiasbeyer
    ];
    mainProgram = "git-graph";
  };
})
