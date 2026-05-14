{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anchor";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "solana-foundation";
    repo = "anchor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J8q+oNT6x36LlTO/szlkxIcT5oFJ3y8b3YyqwBjDYX8=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-c+xhJas+SnnUshhpLx+C/4SH0uow/QG/1NlAbz9ePDc=";

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
    maintainers = with lib.maintainers; [
      Denommus
      _0xgsvs
    ];
    mainProgram = "anchor";
  };
})
