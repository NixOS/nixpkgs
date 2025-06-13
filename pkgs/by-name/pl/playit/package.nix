{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "playit";
  version = "0.15.26";

  src = fetchFromGitHub {
    owner = "playit-cloud";
    repo = "playit-agent";
    rev = "v${version}";
    hash = "sha256-zmiv007/am9KnxpauelNNrfdJuJSqmDspLKqP6pCjIs=";
  };

  cargoHash = "sha256-HIwoPmxMvq3zlhzqSNKZVnWUxW9jE6c0lzztmSYpHzM=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  doCheck = false;

  meta = with lib; {
    description = "Global proxy to run an online game server";
    homepage = "https://github.com/playit-cloud/playit-agent";
    license = licenses.bsd2;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "playit-cli";
  };
}
