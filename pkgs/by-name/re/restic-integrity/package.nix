{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "restic-integrity";
  version = "1.4.0";

  src = fetchFromGitea {
    domain = "git.nwex.de";
    owner = "networkException";
    repo = "restic-integrity";
    tag = version;
    hash = "sha256-Nii+rdz51+Acd+lZVpBispeFfVE8buxEGHvK2zMKbOM=";
  };

  cargoHash = "sha256-Hnr003TbG0y/Ry4yOAs6t6rhc5yEJkc+TDAuxGePb0Y=";

<<<<<<< HEAD
  meta = {
    description = "CLI tool to check the integrity of a restic repository without unlocking it";
    homepage = "https://git.nwex.de/networkException/restic-integrity";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ networkexception ];
=======
  meta = with lib; {
    description = "CLI tool to check the integrity of a restic repository without unlocking it";
    homepage = "https://git.nwex.de/networkException/restic-integrity";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ networkexception ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "restic-integrity";
  };
}
