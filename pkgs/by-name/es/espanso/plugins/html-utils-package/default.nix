{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "html-utils-package";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A simple package to make coding in HTML5 easier.";
    homepage = "https://github.com/woodenbell/html-utils-package";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
