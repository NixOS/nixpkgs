{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "16.26.1";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-klvYUuk1U6hClSWPQWwJv+uadjaEqkjOZv33PygyrCQ=";
  };

  npmDepsHash = "sha256-S1BYJDap3kW/MWZyv7Acmx+rFdGrWLwBdKlGPgH1RsU=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
