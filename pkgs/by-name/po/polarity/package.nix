{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-04-16";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "ba1e8861a8d32e4fad987b6dcb49d2804dce3cbe";
    hash = "sha256-viwSbYxNcmxNEaPNNThjKxmQx5KO8bEV23KibnCwMQg=";
  };

  cargoHash = "sha256-23qr4bEAsN75ONnNmym9eWH38fRoMmP1EkmOaka73Ko=";

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
