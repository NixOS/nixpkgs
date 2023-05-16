let
  pkgs = import ../../../../.. { };

  src = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "emacs2nix";
<<<<<<< HEAD
    rev = "e5389c3d7be9c3af135f022d86c61767d41c364f";
    sha256 = "sha256-mueyrGXgbjvmXQqPRuLUJdJuB5dqiGGdzCQ74Ud+Z9Y=";
=======
    rev = "2e8d2c644397be57455ad32c2849f692eeac7797";
    sha256 = "sha256-qnOYDYHAQ+r5eegKP9GqHz5R2ig96B2W7M+uYa1ti9M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };
in
pkgs.mkShell {

  packages = [
    pkgs.bash
  ];

  EMACS2NIX = src;

  shellHook = ''
    export PATH=$PATH:${src}
  '';

}
