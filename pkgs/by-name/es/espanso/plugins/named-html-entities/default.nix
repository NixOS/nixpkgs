{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "named-html-entities";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "a5b6dbc16fa52e717f92a3667323cfd8646b47e0";
    hash = "sha256-QoQqI1cKgX9Xkl6u5t0TggrjiNsn0N+nZsRVGh812Mg=";
  };

  meta = {
    description = "Replace HTML named entity references with their corresponding characters";
    homepage = "https://github.com/mrled/espanso-named-html-entities";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
