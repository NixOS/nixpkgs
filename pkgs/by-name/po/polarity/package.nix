{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-01-23";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "b5449d485a86fec9d88621cc38fcdfd9b4c3c2d1";
    hash = "sha256-MFem+/7LegSXJXlIQkaVLbTfxvuG46V10TI06NohQ9A=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
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
