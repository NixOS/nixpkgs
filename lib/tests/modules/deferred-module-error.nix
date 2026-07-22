{ config, lib, ... }:
let
  inherit (lib)
    types
    mkOption
    evalModules
    ;
  inherit (types)
    deferredModule
    ;
in
{
  options = {
    deferred = mkOption {
      type = deferredModule;
    };
    result = mkOption {
      default = (evalModules { modules = [ config.deferred ]; }).config.result;
    };
  };
  config = {
    deferred =
      { ... }:
      # this should be an attrset, so this fails
      true;
  };
}
