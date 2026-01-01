{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
<<<<<<< HEAD
  version = "0.49.0";
=======
  version = "0.48.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-o4fa5lO8fTf5Nb2kGUqCRK/v5rQOlmHbnzCx9l7S3So=";
  };

  cargoHash = "sha256-ceDdBBolkQYI3F58DgKztWfULvc5jVp69FDdk6NxcLU=";
=======
    sha256 = "sha256-zJjP1EBfJ/f1HI1rMv8ADQqpjLcnPLgajZB4rTUayB4=";
  };

  cargoHash = "sha256-soNKxIOvxqFYEaycagF56Hp/UM7a79g8+ScO7zsPqvM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${version}/changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      kivikakk
    ];
  };
}
