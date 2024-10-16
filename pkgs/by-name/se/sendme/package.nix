{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YnabQ8YHDsFYu5RX3E2NvPARsl+qn4688q9KxZ5Fegc=";
  };

  cargoHash = "sha256-yD40QKceLjtq80K6I98bT27sCAkCnkRkfE3m4eGjueU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
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
