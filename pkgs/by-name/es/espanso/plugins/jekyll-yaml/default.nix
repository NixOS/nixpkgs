{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "jekyll-yaml";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A simple package to add metadata to your jekyll posts before writing.";
    homepage = "https://github.com/nullnein/espanso-hub/tree/main";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
