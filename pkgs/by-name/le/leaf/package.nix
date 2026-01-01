{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "leaf";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "IogaMaster";
    repo = "leaf";
    rev = "v${version}";
    hash = "sha256-y0NO9YcOO7T7Cqc+/WeactwBAkeUqdCca87afOlO1Bk=";
  };

  cargoHash = "sha256-RQ9fQfYfpsFAA5CzR3ICLIEYb00qzUsWAQKSrK/488g=";

<<<<<<< HEAD
  meta = {
    description = "Simple system fetch written in rust";
    homepage = "https://github.com/IogaMaster/leaf";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Simple system fetch written in rust";
    homepage = "https://github.com/IogaMaster/leaf";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "leaf";
  };
}
