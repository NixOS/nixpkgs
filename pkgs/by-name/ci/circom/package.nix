{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "circom";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "iden3";
    repo = "circom";
    rev = "v${version}";
    hash = "sha256-BSInX4owuamRWnlKL1yJJOyzRIiE55TIzCk2TdX7aOQ=";
  };

  cargoHash = "sha256-dkgLp6BKuublS97iRXYzbT4ztbWBD5IDMz9rDY9XgcA=";
  doCheck = false;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "zkSnark circuit compiler";
    mainProgram = "circom";
    homepage = "https://github.com/iden3/circom";
    changelog = "https://github.com/iden3/circom/blob/${src.rev}/RELEASES.md";
<<<<<<< HEAD
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ raitobezarius ];
=======
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
