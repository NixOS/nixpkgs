{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.deferred-module = mkOption {
    type = types.deferredModuleWith {
      staticModules = [
        {
          options.merged = mkOption {
            type = types.str;
            default = "merged-default";
          };
        }
      ];
    };
  };
}
