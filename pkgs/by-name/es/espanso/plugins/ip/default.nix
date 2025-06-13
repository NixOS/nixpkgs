{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  dig,
}:
mkEspansoPlugin {
  pname = "ip";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [ dig ];

  meta = {
    description = "Display your public IP with :ip ( Linux only )";
    homepage = "https://github.com/profy12/espanso-package-ip";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
