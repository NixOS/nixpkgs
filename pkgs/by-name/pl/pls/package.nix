{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "pls";
  version = "0.0.1-beta.2";

  src = fetchFromGitHub {
    owner = "dhruvkb";
    repo = "pls";
    rev = "v${version}";
    hash = "sha256-yMZygYrLi3V9MA+6vgqG+RHme5jtHMnork8aALbFVXc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "users-0.11.0" = "sha256-xBds73h68oWjKivEw92jEx0dVh08H2EIlBWnGx9DhyE=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    description = "Prettier and powerful ls";
    homepage = "https://pls-rs.github.io/pls/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pls";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
