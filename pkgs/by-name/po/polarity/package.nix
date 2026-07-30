{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polarity";
  version = "0-unstable-2026-05-20";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "522f7a7b70608cda6ce3207c81d26bef17b0cdf9";
    hash = "sha256-o2+tOrWr8Rjy+r05PX9C6qtx70HDyhWlvza2Ssw15mk=";
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
