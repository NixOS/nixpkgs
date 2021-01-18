let
  pkgs = import ../../../.. { };

  src = pkgs.fetchgit {
    url = "https://github.com/ttuegel/emacs2nix.git";
    fetchSubmodules = true;
    rev = "b815a9323c1f58f6c163a1f968939c57a8b6cfa0";
    sha256 = "183xlmhjmj4z2zssc0pw990h7bf3bam8zqswnf1zcsyp8z7yrl5g";
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
