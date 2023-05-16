{ lib
, trivialBuild
, fetchFromGitHub
, emacs
}:

<<<<<<< HEAD
trivialBuild {
  pname = "sunrise-commander";
  version = "unstable=2021-09-27";

  src = fetchFromGitHub {
    owner = "sunrise-commander";
    repo = "sunrise-commander";
=======
trivialBuild rec {
  pname = "sunrise-commander";
  version = "0.pre+unstable=2021-09-27";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rev = "16e6df7e86c7a383fb4400fae94af32baf9cb24e";
    hash = "sha256-D36qiRi5OTZrBtJ/bD/javAWizZ8NLlC/YP4rdLCSsw=";
  };

  buildInputs = [
    emacs
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/sunrise-commander/sunrise-commander/";
    description = "Orthodox (two-pane) file manager for Emacs";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://github.com/sunrise-commander/sunrise-commander/";
    description = "Orthodox (two-pane) file manager for Emacs";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.all;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
