{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  curl,
}:
mkEspansoPlugin {
  pname = "wtc";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [ curl ];

  meta = {
    description = "Get a hilarious random commit message";
    homepage = "https://github.com/omrilotan/espanso-package-wtc";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
