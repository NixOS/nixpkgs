{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ludtwig";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = "ludtwig";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-V0T+yinjTVkAXA604bfEGDzpCd0saNt5S71XFaFqdxg=";
=======
    hash = "sha256-3E1W6AlGQ9AhMzLvTV5KBjlKiWXyi7rFwHOdU3CIp60=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  checkType = "debug";

<<<<<<< HEAD
  cargoHash = "sha256-qR7V7fvWsDsLDRwfvM5UV7iKLGxE722eXvYrZTBtGpQ=";

  meta = {
    description = "Linter / Formatter for Twig template files which respects HTML and your time";
    homepage = "https://github.com/MalteJanz/ludtwig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  cargoHash = "sha256-00JHtrDffFl3h3IOH+h491qGOSfXIJH9NBmaqqUtQ6k=";

  meta = with lib; {
    description = "Linter / Formatter for Twig template files which respects HTML and your time";
    homepage = "https://github.com/MalteJanz/ludtwig";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      maltejanz
    ];
    mainProgram = "ludtwig";
  };
}
