{ lib, ... }:

{
  imports = [
    ./recursive.nix
  ];

  options.success = lib.mkOption {
    type = lib.types.bool;
  };

  config.success = true;
}
