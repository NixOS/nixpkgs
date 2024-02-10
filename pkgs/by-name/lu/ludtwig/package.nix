{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ludtwig";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nNr0iis+wBd+xKJYQL7OWlQnU1DhKztsPHCq3+tX79w=";
  };

  checkType = "debug";

  cargoHash = "sha256-Utho/foZOPz5K3WrOZjAkxvw7+J0RtbW0xvw/Txu/xk=";

  meta = with lib; {
    description = "Linter / Formatter for Twig template files which respects HTML and your time";
    homepage = "https://github.com/MalteJanz/ludtwig";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim maltejanz ];
    mainProgram = "ludtwig";
  };
}
