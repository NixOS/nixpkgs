{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-graph";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mlange-42";
    repo = "git-graph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9GFwxWYDnH3kKDWpxgh7ciSLB1Zr2zExxIrIrhycmZY=";
  };

  cargoHash = "sha256-hKCEAXZj2ExSamvtl10RnAiuV9w6yOYdnsXm0gplFSU=";

  meta = {
    description = "Command line tool to show clear git graphs arranged for your branching model";
    homepage = "https://github.com/mlange-42/git-graph";
    license = lib.licenses.mit;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [
      cafkafk
      matthiasbeyer
    ];
    mainProgram = "git-graph";
  };
})
