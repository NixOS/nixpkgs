{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "htmlhint";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "htmlhint";
    repo = "HTMLHint";
    rev = "v${version}";
    hash = "sha256-h40diAM96jQRXIaPqDoQCoB4guMJCMIr9MxbpB7bb8A=";
  };

  npmDepsHash = "sha256-VCeMyreQb9DjX1Leyt0vvoejdgG11Rhs3PAFsieeSCs=";

  meta = {
    changelog = "https://github.com/htmlhint/HTMLHint/blob/${src.rev}/CHANGELOG.md";
    description = "Static code analysis tool for HTML";
    homepage = "https://github.com/htmlhint/HTMLHint";
    license = lib.licenses.mit;
    mainProgram = "htmlhint";
    maintainers = [ ];
  };
}
