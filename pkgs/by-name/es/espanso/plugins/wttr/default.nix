{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  curl,
}:
mkEspansoPlugin {
  pname = "wttr";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [ curl ];

  meta = {
    description = "A package to get the weather from wttr.in.";
    homepage = "https://github.com/bradyjoslin/espanso-package-wttr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
