{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "sitelen-pona";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package for writing UCSUR sitelen pona with Espanso!";
    homepage = "https://github.com/neroist/sitelen-pona-ucsur-guide";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
