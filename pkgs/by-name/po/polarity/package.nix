{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polarity";
  version = "latest-unstable-2026-03-16";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "02610d9df01cd3297fc68d0df6b63a9eaa37585e";
    hash = "sha256-37/dcuaN1QoCvjzrHin1PFzzFvpH5prQHonsX9WLq0o=";
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
