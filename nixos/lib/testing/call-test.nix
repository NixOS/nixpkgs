{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    result = mkOption {
      internal = true;
      default = config;
    };
  };
}
