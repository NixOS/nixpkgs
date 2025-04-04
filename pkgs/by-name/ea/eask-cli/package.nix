{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "eask-cli";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    rev = version;
    hash = "sha256-xMay2HGw5vGvGIrbjCk0LNn5bvSiHbnpjfdGdO7BpQ4=";
  };

  npmDepsHash = "sha256-8/2DCFlQ0bQt9uajWm17qqp2zc8scHdscL6n/laSZZ8=";

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
