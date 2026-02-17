{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "subxt";
  version = "0.44.2";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3yTX2H4T0nnA0Kh1Lx1/blK/Edd1ZOHQVEXiiOLxino=";
  };

  cargoHash = "sha256-zJpzsPHK9Mq0KF0WvbBINxSQVr0m4Z5+M6/nFD8jiMg=";

  # Only build the command line client
  cargoBuildFlags = [
    "--bin"
    "subxt"
  ];

  # Needed by wabt-sys
  nativeBuildInputs = [ cmake ];

  # Requires a running substrate node
  doCheck = false;

  meta = {
    homepage = "https://github.com/paritytech/subxt";
    description = "Submit transactions to a substrate node via RPC";
    mainProgram = "subxt";
    license = with lib.licenses; [
      gpl3Plus
      asl20
    ];
    maintainers = [ lib.maintainers.FlorianFranzen ];
  };
})
