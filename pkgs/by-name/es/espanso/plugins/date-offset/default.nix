{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "date-offset";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package that uses the date-handling facilities of different scripting languages to return dates variably offset from today, as specified in a regex trigger.";
    homepage = "https://github.com/smeech";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
