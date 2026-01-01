{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "bingrep";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "m4b";
    repo = "bingrep";
    rev = "v${version}";
    hash = "sha256-bHu3/f25U1QtRZv1z5OQSDMayOpLU6tbNaV00K55ZY8=";
  };

  cargoHash = "sha256-cGDFbf8fUGbuxl8tOvKss5tqpBd1TY7TcwNzWwdw12A=";

<<<<<<< HEAD
  meta = {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    mainProgram = "bingrep";
    homepage = "https://github.com/m4b/bingrep";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minijackson ];
=======
  meta = with lib; {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    mainProgram = "bingrep";
    homepage = "https://github.com/m4b/bingrep";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
