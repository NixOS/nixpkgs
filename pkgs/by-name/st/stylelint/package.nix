{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "16.15.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-9PaRsBvs8TDpL2I5nPr+vWGzx4TJEWvKIoMuTq9qI5k=";
  };

  npmDepsHash = "sha256-gVaXq83XeYnEA6s37Y0Bwo5Y14bPr/Q7mYMNQFFcw38=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
