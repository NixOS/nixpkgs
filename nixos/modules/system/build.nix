{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {

    system.build = mkOption {
      internal = true;
      default = {};
      type = types.lazyAttrsOf types.unspecified;
      description = ''
        Attribute set of derivations used to set up the system.
      '';
    };

  };
}
