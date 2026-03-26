{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {

    system.build = mkOption {
      description = ''
        Attribute set of derivations used to set up the system.
      '';
      type = types.submoduleWith {
        modules = [
          {
            freeformType = with types; lazyAttrsOf (uniq unspecified);
          }
        ];
      };
    };

  };
}
