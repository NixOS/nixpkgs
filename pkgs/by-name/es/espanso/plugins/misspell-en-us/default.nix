{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "misspell-en-us";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Replace british english with american english.";
    homepage = "https://github.com/timorunge/espanso-misspell-en";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
