{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polarity";
  version = "latest-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "630a1bb3b97c7c1a13087407a50cc78316a2526e";
    hash = "sha256-IuT1LJiMEOS+c4dUamCpboDNqHGDVxsjYBJ4NEmLZa4=";
  };

  cargoHash = "sha256-FrCOsgbb0xQH3cKnWqa2n17uDpppnSd0PyVrrCPXCYw=";

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
