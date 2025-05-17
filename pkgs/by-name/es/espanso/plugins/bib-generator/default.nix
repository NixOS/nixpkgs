{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  python3,
}:
mkEspansoPlugin {
  pname = "bib-generator";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [
    python3
  ];

  meta = {
    description = "Generate a BibTex entry by searching through DBLP";
    homepage = "https://github.com/Xeophon/hub/tree/main/packages/bib-generator";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
