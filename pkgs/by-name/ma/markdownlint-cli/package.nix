{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "markdownlint-cli";
  version = "0.49.1";

  src = fetchFromGitHub {
    owner = "igorshubovych";
    repo = "markdownlint-cli";
    rev = "v${version}";
    hash = "sha256-+zR/A7cp85ggX8MwidRzIPQ54Su4SyGOQtWy9c6fdk8=";
  };

  npmDepsHash = "sha256-UMaE1ZAha8D8v387YlVn47AEu6YwNop1yh80gd1Gwh4=";

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for MarkdownLint";
    homepage = "https://github.com/igorshubovych/markdownlint-cli";
    license = lib.licenses.mit;
    mainProgram = "markdownlint";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
