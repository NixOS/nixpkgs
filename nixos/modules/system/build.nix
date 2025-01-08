{ lib, ... }:
let
  inherit (lib) lib.mkOption types;
in
{
  options = {

    system.build = lib.mkOption {
      default = { };
      description = ''
        Attribute set of derivations used to set up the system.
      '';
      type = lib.types.submoduleWith {
        modules = [
          {
            freeformType = with lib.types; lazyAttrsOf (uniq unspecified);
          }
        ];
      };
    };

  };
}
