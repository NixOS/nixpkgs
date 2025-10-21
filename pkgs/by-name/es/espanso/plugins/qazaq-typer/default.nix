{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "qazaq-typer";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Faster method to type Qazaq on latin and Cirilic. AA -> Ә ";
    homepage = "https://github.com/soulllink/Qazaq-Typer";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
