{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "star-rating";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "a5b6dbc16fa52e717f92a3667323cfd8646b47e0";
    hash = "sha256-QoQqI1cKgX9Xkl6u5t0TggrjiNsn0N+nZsRVGh812Mg=";
  };

  meta = {
    description = "Display a star rating. However you want, wherever you want. You decide";
    homepage = "https://github.com/jacobfresco/star-rating/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
