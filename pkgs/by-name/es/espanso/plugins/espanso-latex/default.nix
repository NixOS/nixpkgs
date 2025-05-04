{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "espanso-latex";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "An espanso package to convert LaTeX symbol commands to Unicode symbols.";
    homepage = "https://github.com/zoenglinghou/espanso-latex";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
