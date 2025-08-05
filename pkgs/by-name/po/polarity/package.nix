{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-07-30";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "2f7056d3c201680c9a7f267b4f39e82518bc5660";
    hash = "sha256-9H6ICxrZICjfR+URnVVFGdk4lVUp89EIbaHrToDRUNQ=";
  };

  cargoHash = "sha256-SXGuf/JaBfPZgbCAfRmC2Gd82kOn54VQrc7FdmVJRuA=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
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
