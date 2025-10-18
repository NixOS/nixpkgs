{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "form-list";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Uses a CSV to present a list of links and then pastes the chosen URL.";
    homepage = "https://github.com/smeech";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
