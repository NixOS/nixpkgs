{ config, lib, ... }:
let
  inherit (lib) types mkOption setDefaultModuleLocation evalModules;
  inherit (types) deferredModule lazyAttrsOf submodule str raw enum;
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
    deferred = { ... }:
      # this should be an attrset, so this fails
      true;
  };
}
