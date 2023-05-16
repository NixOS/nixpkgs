<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.2.2";
=======
{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-5U6+16gy5s+1zDSxy6rMheZFAbpiya3uxvr21VaHDZQ=";
  };

  cargoHash = "sha256-O5fPV20OSEMv7Yw982ZorhN7y3NTzrprS79n2ID0LwU=";
=======
    sha256 = "sha256-puChbaLjpm5FmpYIrb+3eKO9BSFu99R5j4ymKH5359Y=";
  };

  cargoSha256 = "sha256-DKpZQZgMR+gbcxxAD8ru5O4o7vr6n4seBVqor3HrYtY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
<<<<<<< HEAD
    changelog = "https://github.com/max-niederman/ttyper/releases/tag/${src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
  };
}
