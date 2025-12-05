{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-zJjP1EBfJ/f1HI1rMv8ADQqpjLcnPLgajZB4rTUayB4=";
  };

  cargoHash = "sha256-soNKxIOvxqFYEaycagF56Hp/UM7a79g8+ScO7zsPqvM=";

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
