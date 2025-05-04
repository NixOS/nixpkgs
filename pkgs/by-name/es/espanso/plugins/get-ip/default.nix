{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  curl,
}:
mkEspansoPlugin {
  pname = "get-ip";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [
    curl
  ];

  meta = {
    description = "A espanso package to get IP address";
    homepage = "https://github.com/yogeshbatra/espanso-get-ip-pack";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
