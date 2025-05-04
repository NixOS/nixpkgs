{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  translate-shell,
}:
mkEspansoPlugin {
  pname = "quick-translate";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [ translate-shell ];

  meta = {
    description = "A Package to quickly translate text of various languages";
    homepage = "https://github.com/p0ly60n/quick-translate";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
