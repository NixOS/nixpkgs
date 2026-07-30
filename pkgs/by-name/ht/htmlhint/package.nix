{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "htmlhint";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "htmlhint";
    repo = "HTMLHint";
    rev = "v${version}";
    hash = "sha256-jqlTtLC9tCGVU9w5xC3Lgr61SOo96yk2rIG0LjYGklw=";
  };

  npmDepsHash = "sha256-baMVZNwKwXVQCkIgaQizYe9vjYKJXggUXsGMZmSrwdY=";

  meta = {
    changelog = "https://github.com/htmlhint/HTMLHint/blob/${src.rev}/CHANGELOG.md";
    description = "Static code analysis tool for HTML";
    homepage = "https://github.com/htmlhint/HTMLHint";
    license = lib.licenses.mit;
    mainProgram = "htmlhint";
    maintainers = [ ];
  };
}
