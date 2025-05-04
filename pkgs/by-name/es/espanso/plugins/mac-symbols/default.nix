{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "mac-symbols";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Display common Mac symbols like ⌘ and ⌥";
    homepage = "https://github.com/lifesign/espanso-mac-symbols";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
