{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polarity";
  version = "latest-unstable-2026-08-10";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "2d8ad195effd61daa95e97aa3d1e172eefca5e9a";
    hash = "sha256-EagBLOqLrTKwCR/yQ5docjq2VFD1u907haQqs9bPM6M=";
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
