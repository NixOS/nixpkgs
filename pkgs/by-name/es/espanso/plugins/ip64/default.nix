{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  curl,
}:
mkEspansoPlugin {
  pname = "ip64";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [ curl ];

  meta = {
    description = "Replace :ipv4 with your external IPv4 and :ip6 with your IPv6 (Linux and MacOS)";
    homepage = "https://github.com/tweinreich/espanso-package-ip64";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
