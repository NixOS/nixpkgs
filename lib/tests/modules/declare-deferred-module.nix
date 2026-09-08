{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.final = mkOption {
    type = types.submoduleWith {
      modules = [ config.deferred-module ];
    };
  };

  options.deferred-module = mkOption {
    type = types.deferredModule;
    default = { };
  };
}
