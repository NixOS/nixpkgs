let
  pkgs = import ../. {
    config = { };
    overlays = [ ];
  };
in
pkgs.nixpkgs-manual.shell
