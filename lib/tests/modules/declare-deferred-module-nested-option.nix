{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  config.deferred-module = {
    options.nested = mkOption {
      type = types.str;
      default = "nested-default";
    };
  };
}
