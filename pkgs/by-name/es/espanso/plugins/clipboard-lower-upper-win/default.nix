{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "clipboard-lower-upper-win";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A simple espanso package to convert clipboard content to lower and upper case in Windows";
    homepage = "https://github.com/saravanabalagi/espanso-clipboard-lower-upper-win";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = lib.platforms.windows;
  };
}
