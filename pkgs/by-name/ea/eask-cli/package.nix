{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "eask-cli";
<<<<<<< HEAD
  version = "0.12.0";
=======
  version = "0.11.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-W7RteTkfQMOxMTfEfDr9cQCXpQ3yPExLwdlrh7iR0EI=";
  };

  npmDepsHash = "sha256-C/5PZv732ZrnGXrlrWZmjJzdyJ+tGAJ5UAw96hh6gaU=";
=======
    hash = "sha256-yI227/ZC+4qyg/H+4yuv1imuwIyCB8wDZ7Z3f0OPqXI=";
  };

  npmDepsHash = "sha256-v1o9ZSA+WRYjj2bH+w3lOCXbzqHvsHuvOejU8Ea9PR8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
