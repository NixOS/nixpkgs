{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "eask-cli";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    rev = version;
    hash = "sha256-G6bJoNKEz0Lpp3vfJJ86r942dWdMhQLJn10YXjUKJtI=";
  };

  npmDepsHash = "sha256-xZBnjhLHceLvYD9uPz5G9EupBBUAkBghxo5au0GxdWg=";

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
