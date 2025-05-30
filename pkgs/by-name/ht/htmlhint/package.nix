{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "htmlhint";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "htmlhint";
    repo = "HTMLHint";
    rev = "v${version}";
    hash = "sha256-kn1HwOHJq4B+R/YIFQvvvG4efA7iVUVWLV8vfzbNEpA=";
  };

  npmDepsHash = "sha256-8YeaMU/maXN8Vvy5BYqge4Ky5/Ln4GJ7stVe3y+8uU4=";

  meta = {
    changelog = "https://github.com/htmlhint/HTMLHint/blob/${src.rev}/CHANGELOG.md";
    description = "Static code analysis tool for HTML";
    homepage = "https://github.com/htmlhint/HTMLHint";
    license = lib.licenses.mit;
    mainProgram = "htmlhint";
    maintainers = [ ];
  };
}
