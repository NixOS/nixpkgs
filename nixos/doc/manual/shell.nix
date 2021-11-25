let
  pkgs = import ../../.. { };
in
pkgs.mkShell {
  name = "nixos-manual";

  packages = with pkgs; [ xmlformat jing xmloscopy ruby ];
}
