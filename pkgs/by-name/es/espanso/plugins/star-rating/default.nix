{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "star-rating";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Display a star rating. However you want, wherever you want. You decide";
    homepage = "https://github.com/jacobfresco/star-rating/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
