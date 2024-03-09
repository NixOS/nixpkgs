{ lib, ... }:
{

  imports = [
    "${builtins.toFile "drv" "{}"}"
    ./declare-enable.nix
    ./define-enable.nix
  ];

}

