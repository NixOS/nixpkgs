let
  pkgs = import ../../../.. { };

  src = pkgs.fetchgit {
    url = "https://github.com/ttuegel/emacs2nix.git";
    fetchSubmodules = true;
    rev = "798542b34dc8d7f5c110119350bd9bafef9f8439";
    sha256 = "1lna9z90sxjnanggjh2si018cfzp60xsrissnv9bbkc8wish1537";
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
