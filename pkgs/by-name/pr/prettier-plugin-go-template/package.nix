{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "prettier-plugin-go-template";

  src = fetchFromGitHub {
    owner = "NiklasPor";
    repo = "prettier-plugin-go-template";
    rev = "d91c82e1377b89592ea3365e7e5569688fbc7954";
    hash = "sha256-3Tvh+OzqDTtzoaTp5dZpgEQiNA2Y2dbyq4SV9Od499A=";
  };

  npmDepsHash = "sha256-PpJnVZFRxpUHux2jIBDtyBS4qNo6IJY4kwTAq6stEVQ=";

  meta = {
    description = "Fixes prettier formatting for go templates";
    homepage = "https://github.com/NiklasPor/prettier-plugin-go-template";
    license = lib.licenses.mit;
    mainProgram = "prettier-plugin-go-template";
    maintainers = with lib.maintainers; [ jukremer ];
  };
}
