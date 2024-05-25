{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dumbpipe";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-el7cP00qWEAujtBtkMdF3/F09LQ0xMi6A140wErjzKk=";
  };

  cargoHash = "sha256-ucNMoKF9c5TFyFv8HYH3wypGQGTuZ6BT5/cuEIsyykI=";

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
