{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anchor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "solana-foundation";
    repo = "anchor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y5452JSBAH+GkAJ57cDjup3vyMzPac+xvNAE+W81Ong=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-GH/R7S8jQAWGTz8Ig/u/yb9o6FPtmkAaOzgl0uiB0dk=";

  # Only build the anchor-cli package
  cargoBuildFlags = [
    "-p"
    "anchor-cli"
  ];

  # Only run tests for the anchor-cli
  cargoTestFlags = [
    "-p"
    "anchor-cli"
  ];

  meta = {
    description = "Solana Sealevel Framework";
    homepage = "https://github.com/solana-foundation/anchor";
    changelog = "https://github.com/solana-foundation/anchor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Denommus ];
    mainProgram = "anchor";
  };
})
