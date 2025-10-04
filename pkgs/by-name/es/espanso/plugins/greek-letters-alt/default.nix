{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "greek-letters-alt";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Expand :[letter name] to the corresponding greek letter. The first character determines the letter case";
    homepage = "https://github.com/Su-Well/espanso-package-greek-letters";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
