{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "markdownlint-cli";
  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "igorshubovych";
    repo = "markdownlint-cli";
    rev = "v${version}";
    hash = "sha256-sepA0XUAXzhjKiHrOwtoXN9rJ3t6ge9vA5xYNzIHyDs=";
  };

  npmDepsHash = "sha256-pFJKEntmpO8CskQiSEqTwDxVZbdZDa/Uk2HcnMctiz4=";

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for MarkdownLint";
    homepage = "https://github.com/igorshubovych/markdownlint-cli";
    license = lib.licenses.mit;
    mainProgram = "markdownlint";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
