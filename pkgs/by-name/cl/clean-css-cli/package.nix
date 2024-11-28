{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

let
  version = "5.6.3";
  src = fetchFromGitHub {
    owner = "clean-css";
    repo = "clean-css-cli";
    rev = "v${version}";
    hash = "sha256-tsFNcQg55uY2gL5xLLLS6INLlYzbsU6M3hnsYeOFGEw=";
  };
in
buildNpmPackage {
  pname = "clean-css-cli";
  inherit version src;

  npmDepsHash = "sha256-uvI9esVVOE18syHUCJpoiDY+Vh3hJO+GsMOTZSYJaxg=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/clean-css/clean-css-cli/blob/${src.rev}/History.md";
    description = "Command-line interface to the clean-css CSS optimization library";
    homepage = "https://github.com/clean-css/clean-css-cli";
    license = lib.licenses.mit;
    mainProgram = "cleancss";
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
