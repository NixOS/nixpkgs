{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "eask-cli";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    rev = version;
    hash = "sha256-GUOimlbArD1GbeBPfIgcIcGKGHx+fEp6+CMYsqHB0t8=";
  };

  npmDepsHash = "sha256-69yGfQuIot0gKZIvLbMqJ0C3qxjqg3TnRDJl4qYHGrQ=";

  dontBuild = true;

  meta = {
    changelog = "https://github.com/emacs-eask/cli/blob/${src.rev}/CHANGELOG.md";
    description = "CLI for building, runing, testing, and managing your Emacs Lisp dependencies";
    homepage = "https://emacs-eask.github.io/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "eask";
    maintainers = with lib.maintainers; [
      jcs090218
      piotrkwiecinski
    ];
  };
}
