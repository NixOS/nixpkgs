let
  pkgs = import ../../../../.. { };

  src = pkgs.fetchgit {
    url = "https://github.com/nix-community/emacs2nix.git";
    fetchSubmodules = true;
    rev = "703b144eeb490e87133c777f82e198b4e515c312";
    sha256 = "sha256-YBbRh/Cb8u9+Pn6/Bc0atI6knKVjr8jiTGgFkD2FNGI=";
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
