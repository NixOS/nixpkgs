let
  pkgs = import ../../../../.. { };

  src = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "emacs2nix";
    rev = "7f07ac3c3f175630de68153d98a93b9fa24d1eb3";
    sha256 = "sha256-Mh9G8LH3n1ccg+shBoWQRk67yAA+GEYGkk8tjM7W02Y=";
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
