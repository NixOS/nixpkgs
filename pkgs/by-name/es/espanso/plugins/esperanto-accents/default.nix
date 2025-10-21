{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "esperanto-accents";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package to type Esperanto accents. Type a non-accented letter followed by x e.g. cx, gx, hx, jx, sx, ux to get the corresponding letter with accent.";
    homepage = "https://github.com/alexmiranda/espanso-package-esperanto";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
