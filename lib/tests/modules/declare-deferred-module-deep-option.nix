{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.deferred-module.deep = mkOption {
    type = types.str;
    default = "deep-default";
  };
}
