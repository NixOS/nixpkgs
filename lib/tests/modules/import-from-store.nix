{ lib, ... }:
let
  drv = derivation {
    name = "derivation";
    system = builtins.currentSystem;
    builder = "/bin/sh";
    args = [ "-c" "echo {} > $out" ];
  };
in {

  imports = [
    "${drv}"
    ./declare-enable.nix
    ./define-enable.nix
  ];

}
