let
  pkgs = import ../../.. { };
in
pkgs.mkShell {
  name = "nixos-manual";

  buildInputs = with pkgs; [ xmlformat jing xmloscopy ruby ];
}
