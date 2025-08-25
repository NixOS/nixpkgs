{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "air-codes";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A comprehensive package offering a database of airlines and airports' names, based on their IATA designators and codes.";
    homepage = "https://github.com/cl3mcg/espanso-package-air-codes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
