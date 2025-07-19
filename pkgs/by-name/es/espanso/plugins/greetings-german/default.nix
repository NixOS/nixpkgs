{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "greetings-german";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A few greeting snippets";
    homepage = "https://github.com/espanso/hub/tree/main/packages/greetings-german/0.2.0";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
