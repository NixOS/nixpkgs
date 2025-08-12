{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-08-05";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "5adc14a5d3151ed124d89768c382e085caf612ac";
    hash = "sha256-ByTUzruKM0u8SfRM88ogvsGw0JijWAVv8oidVdAGNUs=";
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
