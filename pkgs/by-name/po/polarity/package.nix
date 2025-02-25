{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-02-13";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "48d38742310d320fcf02e585db711ac4f80af742";
    hash = "sha256-GFMgathIgEG7/4Vo+JWczvUpK7RBzyrnPKj12OW80Mc=";
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
