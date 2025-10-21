{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "calc";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Matches to do basic arithmetic using your shell with Espanso version 2.1.0-alpha";
    homepage = "https://github.com/UyCode/espanso-calc-new";
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = lib.platforms.windows;
  };
}
