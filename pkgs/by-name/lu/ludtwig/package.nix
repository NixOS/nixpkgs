{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ludtwig";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = "ludtwig";
    rev = "v${version}";
    hash = "sha256-3E1W6AlGQ9AhMzLvTV5KBjlKiWXyi7rFwHOdU3CIp60=";
  };

  checkType = "debug";

  cargoHash = "sha256-00JHtrDffFl3h3IOH+h491qGOSfXIJH9NBmaqqUtQ6k=";

  meta = with lib; {
    description = "Linter / Formatter for Twig template files which respects HTML and your time";
    homepage = "https://github.com/MalteJanz/ludtwig";
    license = licenses.mit;
    maintainers = with maintainers; [
      maltejanz
    ];
    mainProgram = "ludtwig";
  };
}
