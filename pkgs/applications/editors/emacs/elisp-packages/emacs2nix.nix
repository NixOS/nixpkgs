let
  pkgs = import ../../../../.. { };

  src = pkgs.fetchgit {
    url = "https://github.com/nix-community/emacs2nix.git";
    fetchSubmodules = true;
    rev = "8612e136199b29201703e3e28eba26ddc53f297e";
    sha256 = "sha256-p15KuXS18j8nqy69LPnHcj6ciHLxa/nibshts0HMZ0A=";
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
