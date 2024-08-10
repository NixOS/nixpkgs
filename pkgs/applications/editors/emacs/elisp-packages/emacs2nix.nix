let
  pkgs = import ../../../../.. { };

  src = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "emacs2nix";
    rev = "8454f2857252f32621b8022f797fef9b96862204";
    hash = "sha256-UHHEkY+t/IzWe8jC8bm+p275sKfnL5/v5wbwRDw6FZw=";
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
