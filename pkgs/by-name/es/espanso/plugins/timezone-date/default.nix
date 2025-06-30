{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  python3,
}:
mkEspansoPlugin {
  pname = "timezone-date";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [ python3 ];

  meta = {
    description = "A package that uses Python scripts to offer a choice from the full set of worldwide timezones, returning the current date and time there.";
    homepage = "https://github.com/smeech";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
