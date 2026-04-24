{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anchor";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "solana-foundation";
    repo = "anchor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lpLNocNrSWkf/b34PCmUKqFumdo3LcOyGMtN8O2ciEU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Nx5g+X9cPL71Gf9J/Zp5u6H8rrbDQW6KqTc/Ti+mzow=";

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
