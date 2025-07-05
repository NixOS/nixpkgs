{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "16.21.1";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-obRxkExrLFLt02L1w9FBHrHgN8n+lRsPuSUra66j8hE=";
  };

  npmDepsHash = "sha256-t83R9OQnSY7OVEU+TQWQMotsey/XtXIo7NLG9vyiUng=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
