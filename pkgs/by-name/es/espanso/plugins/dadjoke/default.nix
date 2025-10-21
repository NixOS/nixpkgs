{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  curl,
}:
mkEspansoPlugin {
  pname = "dadjoke";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [ curl ];

  meta = {
    description = "A random dad joke every time";
    homepage = "https://github.com/ivanovyordan/espanso-package-dadjoke";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
