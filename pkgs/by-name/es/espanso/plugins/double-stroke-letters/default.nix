{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "double-stroke-letters";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Easy write 𝕕𝕠𝕦𝕓𝕝𝕖 𝕤𝕥𝕣𝕠𝕜𝕖 𝕝𝕖𝕥𝕥𝕖𝕣𝕤";
    homepage = "https://github.com/kopach/espanso-package-double-stroke-letters";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
