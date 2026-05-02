{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "subxt";
  version = "0.44.2";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3yTX2H4T0nnA0Kh1Lx1/blK/Edd1ZOHQVEXiiOLxino=";
  };

  cargoHash = "sha256-zJpzsPHK9Mq0KF0WvbBINxSQVr0m4Z5+M6/nFD8jiMg=";

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
