{ lib
, rustPlatform
, fetchFromGitHub
, darwin
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "iamb";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    rev = "v${version}";
    hash = "sha256-KKr7dfFSffkFgqcREy/3RIIn5c5IxhFR7CjFJqCmqdM=";
  };

  cargoHash = "sha256-/OBGRE9zualLnMh9Ikh9s9IE9b8mEmAC/H5KUids8a8=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  meta = with lib; {
    description = "A Matrix client for Vim addicts";
    homepage = "https://github.com/ulyssa/iamb";
    changelog = "https://github.com/ulyssa/iamb/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ meain ];
  };
}
