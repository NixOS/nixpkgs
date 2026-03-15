{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polarity";
  version = "latest-unstable-2026-03-07";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "589d3efe086b78cc095af4b745cf61e61f93fb2a";
    hash = "sha256-dssf0sTRQYRfggftd3eSlkEu2ZwFglk8thmDFnL6odA=";
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
