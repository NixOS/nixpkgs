{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "typofixer-en";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "a5b6dbc16fa52e717f92a3667323cfd8646b47e0";
    hash = "sha256-QoQqI1cKgX9Xkl6u5t0TggrjiNsn0N+nZsRVGh812Mg=";
  };

  meta = {
    description = "Collection of typos fixed for English language";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
