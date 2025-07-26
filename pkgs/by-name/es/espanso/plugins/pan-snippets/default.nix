{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "pan-snippets";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "a5b6dbc16fa52e717f92a3667323cfd8646b47e0";
    hash = "sha256-QoQqI1cKgX9Xkl6u5t0TggrjiNsn0N+nZsRVGh812Mg=";
  };

  meta = {
    description = "Snippets for Palo Alto Networks Firewalls and Panorama";
    license = lib.licenses.mit;
    homepage = "https://github.com/itsamemarkus/espanso-pan";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
