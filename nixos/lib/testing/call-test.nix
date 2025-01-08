{ config, lib, ... }:
let
  inherit (lib) lib.mkOption types;
in
{
  options = {
    result = lib.mkOption {
      internal = true;
      default = config;
    };
  };
}
