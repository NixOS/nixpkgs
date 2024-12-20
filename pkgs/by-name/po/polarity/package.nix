{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2024-12-09";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "4ac254214e0b8b1cc0a4782ecac751bc41e514a9";
    hash = "sha256-vuC40ez45KrB+F4La2SG9XRAhFCaFJQnlRc4kY4Ky0o=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "codespan-0.11.1" = "sha256-Wq99v77bqSGIOK/iyv+x/EG1563XSeaTDW5K2X3kSXU=";
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
