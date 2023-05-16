{ lib
, rustPlatform
, fetchFromGitHub
, darwin
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "iamb";
<<<<<<< HEAD
  version = "0.0.8";
=======
  version = "0.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Mt4/UWySC6keoNvb1VDCVPoK24F0rmd0R47ZRPADkaw=";
  };

  cargoHash = "sha256-UbmeEcmUr3zx05Hk36tjsl0Y9ay7DNM1u/3lPqlXN2o=";
=======
    hash = "sha256-KKr7dfFSffkFgqcREy/3RIIn5c5IxhFR7CjFJqCmqdM=";
  };

  cargoHash = "sha256-/OBGRE9zualLnMh9Ikh9s9IE9b8mEmAC/H5KUids8a8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
