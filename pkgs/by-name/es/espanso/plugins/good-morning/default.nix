{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "good-morning";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "a5b6dbc16fa52e717f92a3667323cfd8646b47e0";
    hash = "sha256-QoQqI1cKgX9Xkl6u5t0TggrjiNsn0N+nZsRVGh812Mg=";
  };

  meta = {
    description = "Uses python to create personalized greetings that look like they were manually typed";
    homepage = "https://github.com/josh-reeves/espanso-hub/tree/main/packages/good-morning/0.1.0";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
