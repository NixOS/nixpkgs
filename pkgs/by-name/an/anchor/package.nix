{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anchor";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "otter-sec";
    repo = "anchor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C8e0ELa0q8xOat1F8Br8+XPimxgUZ0sBu2MH8cVlzME=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-0Eq3/WOO869fmk+N6o4/ZgXnpNPV5VFNxdaGStT6Zb4=";

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
    homepage = "https://github.com/otter-sec/anchor";
    changelog = "https://github.com/otter-sec/anchor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Denommus
      _0xgsvs
    ];
    mainProgram = "anchor";
  };
})
