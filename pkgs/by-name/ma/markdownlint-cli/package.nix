{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "markdownlint-cli";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "igorshubovych";
    repo = "markdownlint-cli";
    rev = "v${version}";
    hash = "sha256-x9ind66qFS7k6rBDOiJ6amtVf7LTXmXsNKlnJmF6cJY=";
  };

  npmDepsHash = "sha256-oAUhSdbEMv96dS0lhZMSNXs9sQbu06Lwf45GVj0m+2U=";

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for MarkdownLint";
    homepage = "https://github.com/igorshubovych/markdownlint-cli";
    license = lib.licenses.mit;
    mainProgram = "markdownlint";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
