{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "french-accents";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package to type French with a non-French keyboard layout. It works by replacing keywords like e' with é.";
    homepage = "https://github.com/ottopiramuthu/espanso-package-example";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
