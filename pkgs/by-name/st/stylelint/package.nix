{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "16.25.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-oRDQct7R+ZOQ5bKCc7YZY3JsOg42ZthIgdCDJAH5m9E=";
  };

  npmDepsHash = "sha256-Hwq7UEix1qn6M4jtjlliSVCWLx2XxHBOYo5UEfr+UH0=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
