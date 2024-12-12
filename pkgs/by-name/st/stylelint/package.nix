{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "16.11.0";
in
buildNpmPackage {
  pname = "stylelint";
  inherit version;

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-LcnKytRxIZ5Fzz0tGMM7RBke2g3zu94BjtMkMseM4qc=";
  };

  npmDepsHash = "sha256-l1aP9fmXu5U9t4x5lvJoFTotDv3mLDD5mfc4eVNaZbc=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
