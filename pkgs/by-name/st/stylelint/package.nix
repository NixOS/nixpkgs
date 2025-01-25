{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "16.14.0";
in
buildNpmPackage {
  pname = "stylelint";
  inherit version;

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-AAlo8fGUH+jvUsB66cztLDyKA7j25ZWH0BIM7iiyp+c=";
  };

  npmDepsHash = "sha256-FT6UctAsUP9KTSWENutibhyXjZHOT7t93z90XCAIuv4=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
