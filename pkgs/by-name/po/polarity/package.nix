{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polarity";
  version = "latest-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "19f3e73c3279a4fb2c10dfc9ef50a957889f6247";
    hash = "sha256-RP0rYq6SxGVk5kM5c3Rymz6nyQMKyrAg4L5XQHC699w=";
  };

  cargoHash = "sha256-7vBLZwUpZ/LQ4MO1JZhpErFvh5EQyS+7IN1U5wyAP/E=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
})
