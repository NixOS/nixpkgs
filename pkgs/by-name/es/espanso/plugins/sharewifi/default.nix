{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "sharewifi";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "An espanso package for quickly sharing Wi-Fi passwords and connection details on macOS.";
    homepage = "https://github.com/bradyjoslin/espanso-package-sharewifi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = lib.platforms.darwin;
  };
}
