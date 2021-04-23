let
  pkgs = import ../../../.. { };

  src = pkgs.fetchgit {
    url = "https://github.com/ttuegel/emacs2nix.git";
    fetchSubmodules = true;
    rev = "860da04ca91cbb69c9b881a54248d16bdaaf9923";
    sha256 = "1r3xmyk9rfgx7ln69dk8mgbnh3awcalm3r1c5ia2shlsrymvv1df";
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
