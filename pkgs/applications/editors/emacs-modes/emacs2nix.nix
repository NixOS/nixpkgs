let
  pkgs = import ../../../.. { };

  src = pkgs.fetchgit {
    url = "https://github.com/ttuegel/emacs2nix.git";
    fetchSubmodules = true;
    rev = "752fe1bd891425cb7a4a53cd7b98c194c1fe4518";
    sha256 = "0asfdswh8sbnapbqhbz539zzxmv72f1iviha95iys34sgnd5k1nk";
  };

in pkgs.mkShell {

  buildInputs = [
    pkgs.bash
  ];

  EMACS2NIX = "${src}";

  shellHook = ''
    export PATH=$PATH:${src}
  '';

}
