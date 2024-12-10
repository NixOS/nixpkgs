{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "0-unstable-2024-11-15";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "2f6ce455ec512f3b0cfff0f3ca9c5016e6a4e9de";
    hash = "sha256-viJGqtUsoAZznhfDN3PnPG+LJ5ppVL11eyhuEiTG+IQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "codespan-0.11.1" = "sha256-Wq99v77bqSGIOK/iyv+x/EG1563XSeaTDW5K2X3kSXU=";
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
