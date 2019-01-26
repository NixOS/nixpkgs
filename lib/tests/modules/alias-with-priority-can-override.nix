# This is a test to show that mkAliasOptionModule sets the priority correctly
# for aliased options.

{ config, lib, ... }:

with lib;

{
  options = {
    # A simple boolean option that can be enabled or disabled.
    enable = lib.mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        Some descriptive text
      '';
    };

    # mkAliasOptionModule sets warnings, so this has to be defined.
    warnings = mkOption {
      internal = true;
      default = [];
      type = types.listOf types.str;
      example = [ "The `foo' service is deprecated and will go away soon!" ];
      description = ''
        This option allows modules to show warnings to users during
        the evaluation of the system configuration.
      '';
    };
  };

  imports = [
    # Create an alias for the "enable" option.
    (mkAliasOptionModuleWithPriority [ "enableAlias" ] [ "enable" ])

    # Disable the aliased option, but with a default (low) priority so it
    # should be able to be overridden by the next import.
    ( { config, lib, ... }:
      {
        enableAlias = lib.mkForce false;
      }
    )

    # Enable the normal (non-aliased) option.
    ( { config, lib, ... }:
      {
        enable = true;
      }
    )
  ];
}
