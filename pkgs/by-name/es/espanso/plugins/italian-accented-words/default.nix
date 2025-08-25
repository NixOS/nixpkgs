{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "italian-accented-words";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "List of substitutions of Italian accented words";
    homepage = "https://github.com/aecant/espanso-italian-accented-words";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
