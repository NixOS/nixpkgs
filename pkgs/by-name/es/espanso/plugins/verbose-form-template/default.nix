{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "verbose-form-template";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Espanso shortcode to create espanso forms with the list extension";
    homepage = "https://github.com/menawi/hub/tree/main/packages";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
