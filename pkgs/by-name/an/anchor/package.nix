{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anchor";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "otter-sec";
    repo = "anchor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lbNAMEqRYkyRojs8r9pDZI36DTBzHuyP7LSvHd5cZi8=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-8AX5G2j9KMjq6vaby4/RGXXSDHNwJsYiEYHJsoeDJaM=";

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
