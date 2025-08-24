{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "better-typography";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package to help convert quotes into smart quotes.";
    homepage = "https://github.com/jwliles/better-typography";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
