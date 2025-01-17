{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "16.13.0";
in
buildNpmPackage {
  pname = "stylelint";
  inherit version;

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-9OMhOkI8SYetzr4yCuEvFEwHGi/sqOjA0CfUVTc7EIE=";
  };

  npmDepsHash = "sha256-mGuoNhCoOJnKQxdySMTVCi/dRwgIiSlg/LkqeS01gnk=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
