<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = "joshuto";
    rev = "v${version}";
    hash = "sha256-b13CLfWidqfYhHC9wY84kd3elsjWGxBMGr5GXHzUhfs=";
  };

  cargoHash = "sha256-gMX8hvt20V4XUd0nnXGA4fyOUfB7ZY1eeme9HgYopL0=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];
=======
{ lib, rustPlatform, fetchFromGitHub, stdenv, SystemConfiguration, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sSrXBPZe9R8s+MzWA7cRlaRCyf/4z2qb6DrUCgvKQh8=";
  };

  cargoSha256 = "sha256-e4asmP/wTnX6/xrK6lAgCkRlGRFniveEiL5GRXVzcZg=";

  buildInputs = lib.optionals stdenv.isDarwin [ SystemConfiguration Foundation ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Ranger-like terminal file manager written in Rust";
    homepage = "https://github.com/kamiyaa/joshuto";
<<<<<<< HEAD
    changelog = "https://github.com/kamiyaa/joshuto/releases/tag/${src.rev}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ figsoda totoroot xrelkd ];
    mainProgram = "joshuto";
=======
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ figsoda totoroot ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
