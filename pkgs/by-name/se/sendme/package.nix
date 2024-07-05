{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hqhUtMZ3x4zePEjglHgQbzyqxijZX4q45Q4nsPwSeWc=";
  };

  cargoHash = "sha256-Pux0Cqw9ZUrP98ydw7sI0vPZ7w7bcWKTM2FpDv3uzAQ=";

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [
      SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "Tool to send files and directories, based on iroh";
    homepage = "https://iroh.computer/sendme";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "sendme";
  };
}
