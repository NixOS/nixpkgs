{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dumbpipe";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UCPg917stw8zE6B0hdHyzq98icHpr+Z3b5RL4sZim1w=";
  };

  cargoHash = "sha256-qHdU7t73rBXwU8E2HdErFFlnG8r9H3zcXQSA37h0LFA=";

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [
      SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "Connect A to B - Send Data";
    homepage = "https://www.dumbpipe.dev/";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "dumbpipe";
  };
}
