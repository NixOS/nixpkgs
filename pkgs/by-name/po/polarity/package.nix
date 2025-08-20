{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-01-08";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "bbc91efbc25f77f505d244e96cc566f63f6dc858";
    hash = "sha256-3wKMFX4ubp8bLNhdLoMkZlsP2vfu0wcNpEZrs95xwAY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "codespan-0.11.1" = "sha256-0cUndjWQ44X5zXVfg7YX/asBByWq/hFV1n9tHPBTcfY=";
      "tower-lsp-0.20.0" = "sha256-f3S2CyFFX6yylaxMoXhB1/bfizVsLfNldLM+dXl5Y8k=";
    };
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
}
