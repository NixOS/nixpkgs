{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "subxt";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nMal78+TYZ1f9X/YZhsqOsEIrjxhi9fEcevnQW8u97o=";
  };

  cargoHash = "sha256-sqspcTwODoRzaaUSXT+2yPUTzUqcW1gNu0c1Lv9D1u0=";

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
