{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "translate-es-en";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A proof-of-concept package for bidirectional Spanish-English translation";
    license = with lib.licenses; [
      cc-by-sa-30
      fdl11Plus
    ];
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
