let
  pkgs = import ../../../../.. { };

  src = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "emacs2nix";
    rev = "cf706a3e7a4c56be2d4dc83cc453810dfa023967";
    hash = "sha256-jVbRcjNNKfuOIz76EMbrQxnKCN9d9C+szrk0zC8DaNE=";
    fetchSubmodules = true;
  };
in
pkgs.mkShell {

  packages = [
    pkgs.bash
    pkgs.nixfmt-rfc-style
  ];

  EMACS2NIX = src;

  shellHook = ''
    export PATH=$PATH:${src}
  '';

}
