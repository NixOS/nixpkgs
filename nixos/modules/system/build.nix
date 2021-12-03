{ lib, ... }:
let
  inherit (lib) mkOption types;
in {
  options = {
    # TODO: replace by submodule with free-form type
    system.build = mkOption {
      internal = true;
      default = {};
      type = types.attrs;
      description = ''
        Attribute set of derivations used to set up the system.
      '';
    };
  };
}
