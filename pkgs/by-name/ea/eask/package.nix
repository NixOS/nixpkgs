{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "eask";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    rev = version;
    hash = "sha256-bTig1g9G/2NYlvlo6TBMIQjmCqaC8AOwvTiPDbLv//Q=";
  };

  npmDepsHash = "sha256-JEk+dbLndXn8Bfz9HZWzY9Blk2ZyEf5AH6M4+X1uwaM=";

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
