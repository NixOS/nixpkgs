{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    callTest = mkOption {
      internal = true;
      type = types.functionTo types.raw;
    };
    result = mkOption {
      internal = true;
      default = config.test;
    };
  };
}
