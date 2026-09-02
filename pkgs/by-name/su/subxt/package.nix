{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "subxt";
  version = "0.50.3";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ctViZ1veorf+fmalmaZkqVGJYZTGYYcPeM23UGxRNRg=";
  };

  cargoHash = "sha256-QM6tmLygNjrqqE5ptEjYGAEQDBs08Ix2nYrbujtPv7Q=";

  # Only build the command line client
  cargoBuildFlags = [
    "--bin"
    "subxt"
  ];

  # Requires a running substrate node
  doCheck = false;

  meta = {
    homepage = "https://github.com/paritytech/subxt";
    description = "Subxt is a CLI tool for interacting with chains in the Polkadot network";
    changelog = "https://github.com/paritytech/subxt/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "subxt";
    license = with lib.licenses; [
      gpl3Plus
      asl20
    ];
    maintainers = with lib.maintainers; [
      FlorianFranzen
      kilyanni
    ];
  };
})
