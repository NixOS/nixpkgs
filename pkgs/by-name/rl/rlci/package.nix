{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rlci";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "orsinium-labs";
    repo = "rlci";
    rev = version;
    hash = "sha256-+Hd1Ymm2LKnHUKoUlfN6D6pwebxgwJQHgqwMHXXtP6Y=";
  };

  cargoHash = "sha256-ckHwg7jEXZV0hjZFeR5dbqrt9APcyRV95LikwCFw/fM=";

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Lambda calculus interpreter";
    mainProgram = "rlci";
    homepage = "https://github.com/orsinium-labs/rlci";
    changelog = "https://github.com/orsinium-labs/rlci/releases/tag/${src.rev}";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
