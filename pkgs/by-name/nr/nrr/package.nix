{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, pkg-config
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "nrr";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${version}";
    hash = "sha256-jkI5t+1P7Ae6MkSnyy7Ur3Z0Vt8+hWTgf6dgL5tzhY8=";
  };

  cargoHash = "sha256-9qLeFuaKAGhtyHFHOBS6HA0wAWuk0ZJppVySpMwUGYc=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.IOKit
    libiconv
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "Minimal, blazing fast Node.js script runner";
    maintainers = with maintainers; [ ryanccn ];
    license = licenses.gpl3Only;
    mainProgram = "nrr";
  };
}
