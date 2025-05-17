{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "blackboardletters";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Blackboard or double-barred lettering in Espanso";
    homepage = "https://github.com/j6k4m8/espanso-blackboard";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
