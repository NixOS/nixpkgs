{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "htmlhint";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "htmlhint";
    repo = "HTMLHint";
    rev = "v${version}";
    hash = "sha256-jhn3FWzqwqczB7siHRxpYNLPoC9YhZtkcVyvWdIq93k=";
  };

  npmDepsHash = "sha256-acf6pyv3TsOA3Ulm/OMYZ2R7sMGEcsOXA9hbPXLbX3I=";

  meta = {
    changelog = "https://github.com/htmlhint/HTMLHint/blob/${src.rev}/CHANGELOG.md";
    description = "Static code analysis tool for HTML";
    homepage = "https://github.com/htmlhint/HTMLHint";
    license = lib.licenses.mit;
    mainProgram = "htmlhint";
    maintainers = [ ];
  };
}
