{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "prettier-plugin-go-template";
  version = "0.0.15-unstable-2023-07-26";

  src = fetchFromGitHub {
    owner = "NiklasPor";
    repo = pname;
    rev = "d91c82e1377b89592ea3365e7e5569688fbc7954";
    hash = "sha256-3Tvh+OzqDTtzoaTp5dZpgEQiNA2Y2dbyq4SV9Od499A=";
  };

  npmDepsHash = "sha256-PpJnVZFRxpUHux2jIBDtyBS4qNo6IJY4kwTAq6stEVQ=";

  dontNpmPrune = true;

  postInstall = ''
    cd "$nodeModulesPath"
    find -mindepth 1 -maxdepth 1 -type d | grep -Exv "\./(ulid|prettier)" | xargs rm -rf
  '';

  meta = {
    description = "Fixes prettier formatting for go templates";
    mainProgram = "prettier-plugin-go-template";
    homepage = "https://github.com/NiklasPor/prettier-plugin-go-template";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jukremer ];
  };
}
