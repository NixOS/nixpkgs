{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, cmake
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "subxt";
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${version}";
    hash = "sha256-lCDjqvdjiQktyFAp3KuFHehwapd3BiLxMSLsNK+wDDo=";
  };

  cargoHash = "sha256-RmeV2EYHGbMMAeerQkHcYav+RIVY68Tj66zjcFgjUfQ=";

  # Only build the command line client
  cargoBuildFlags = [ "--bin" "subxt" ];

  # Needed by wabt-sys
  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # Requires a running substrate node
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/paritytech/subxt";
    description = "Submit transactions to a substrate node via RPC";
    mainProgram = "subxt";
    license = with licenses; [ gpl3Plus asl20 ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
