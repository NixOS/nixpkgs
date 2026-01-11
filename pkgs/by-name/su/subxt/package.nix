{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "subxt";
  version = "0.44.1";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${version}";
    hash = "sha256-W4bQVgEvnmYZomLD4ToProCvAKnh94Mw9Rr18b9GVEg=";
  };

  cargoHash = "sha256-AdFO0U3vj7yxhGmpXkn6iIQ8+zS6dd+eGVkWnonoy24=";

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
}
