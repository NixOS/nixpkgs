{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "markdownlint-cli";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "igorshubovych";
    repo = "markdownlint-cli";
    rev = "v${version}";
    hash = "sha256-bT/6bRzpXa86e6T0bJSUm624dbRAux4qgmCc+lOtl3c=";
  };

  npmDepsHash = "sha256-g2+kieF+cq8olfQ5rElNNvp5NYJcg+eTNWnMxSXqlKk=";

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for MarkdownLint";
    homepage = "https://github.com/igorshubovych/markdownlint-cli";
    license = lib.licenses.mit;
    mainProgram = "markdownlint";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
