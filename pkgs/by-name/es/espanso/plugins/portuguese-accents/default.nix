{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "portuguese-accents";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package to type Portuguese with a non-Portuguese keyboard layout.";
    homepage = "https://github.com/tashima42/Portuguese-Accents";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
