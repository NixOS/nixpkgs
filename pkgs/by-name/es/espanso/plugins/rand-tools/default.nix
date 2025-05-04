{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  openssl,
}:
mkEspansoPlugin {
  pname = "rand-tools";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [ openssl ];

  meta = {
    description = "A tool for generating random strings with espanso";
    homepage = "https://github.com/JettChenT/espanso-randtools";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
