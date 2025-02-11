{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ludtwig";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-J5UTVXUExVApA8VVTyhkO2JhpVCK45li9VBN+oM9TBI=";
  };

  checkType = "debug";

  useFetchCargoVendor = true;
  cargoHash = "sha256-oS4YepJWqmbjAhitHOCBUrLEyVo3UpZ8UNOESuG4C2M=";

  meta = with lib; {
    description = "Linter / Formatter for Twig template files which respects HTML and your time";
    homepage = "https://github.com/MalteJanz/ludtwig";
    license = licenses.mit;
    maintainers = with maintainers; [
      shyim
      maltejanz
    ];
    mainProgram = "ludtwig";
  };
}
