{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "linter-control-comments";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A collection of linter control comments (currently: Golint, Rubocop, Clippy, and Shellcheck)";
    homepage = "https://github.com/katrinleinweber/espanso-hub/tree/package-linter-control-comments";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
