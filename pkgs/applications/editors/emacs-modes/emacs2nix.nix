let
  pkgs = import ../../../.. { };

  src = pkgs.fetchgit {
    url = "https://github.com/ttuegel/emacs2nix.git";
    fetchSubmodules = true;
    rev = "d4c52a7b22b0622aecf0b0d59941a4a2b250617c";
    sha256 = "133m0bmm8ahy0jbappgcdjqppkpxf5s9wg4gg254afx3f7yfqzbh";
  };

in pkgs.mkShell {

  buildInputs = [
    pkgs.bash
  ];

  EMACS2NIX = src;

  shellHook = ''
    export PATH=$PATH:${src}
  '';

}
