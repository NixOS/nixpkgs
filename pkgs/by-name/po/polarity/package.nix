{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-07-15";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "83bd1bd5bc461421115333e423f45a7735782638";
    hash = "sha256-+l3pS8IpPvebpX++ezcC05X06f+NnBZBsNVXEHTYh6A=";
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
