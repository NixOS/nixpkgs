{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UaAiHGeSqy4kHO9CZX3kYeECZDo45web6yMbBRVnlhQ=";
  };

  # TODO: Remove lock file and use 'cargoHash' instead once `watchable` crate
  # is upgraded past v1.1.1.
  # See https://github.com/khonsulabs/watchable/issues/1
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [
      SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "A tool to send files and directories, based on iroh";
    homepage = "https://iroh.computer/sendme";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "sendme";
  };
}
