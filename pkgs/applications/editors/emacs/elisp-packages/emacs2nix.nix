let
  pkgs = import ../../../../.. { };

  src = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "emacs2nix";
    rev = "e5389c3d7be9c3af135f022d86c61767d41c364f";
    sha256 = "sha256-mueyrGXgbjvmXQqPRuLUJdJuB5dqiGGdzCQ74Ud+Z9Y=";
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
