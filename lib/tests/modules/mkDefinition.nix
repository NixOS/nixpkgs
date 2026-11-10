{ lib, ... }:
let
  inherit (lib)
    mkOption
    mkDefinition
    mkOptionDefault
    ;
in
{
  imports = [
    {
      _file = "file";
      options.conflict = mkOption {
        default = 1;
      };
      config.conflict = mkDefinition {
        file = "other";
        value = mkOptionDefault 42;
      };
    }
    {
      # Check that mkDefinition works within 'config'
      options.viaConfig = mkOption { };
      config.viaConfig = mkDefinition {
        file = "other";
        value = true;
      };
    }
    {
      # Check mkMerge can wrap mkDefinitions
      # Not the other way around
      options.mkMerge = mkOption {
        type = lib.types.bool;
      };
      config.mkMerge = lib.mkMerge [
        (mkDefinition {
          file = "a.nix";
          value = true;
        })
        (mkDefinition {
          file = "b.nix";
          value = true;
        })
      ];
    }
    {
      # Check mkDefinition can use mkForce on the value
      # Not the other way around
      options.mkForce = mkOption {
        type = lib.types.bool;
        default = false;
      };
      config.mkForce = mkDefinition {
        file = "other";
        value = lib.mkForce true;
      };
    }
    {
      # Currently expects an error
      # mkDefinition doesn't work on option default
      # This is a limitation and might be resolved in the future
      options.viaOptionDefault = mkOption {
        type = lib.types.bool;
        default = mkDefinition {
          file = "other";
          value = true;
        };
      };
    }
  ];
}
