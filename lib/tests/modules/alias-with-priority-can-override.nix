# This is a test to show that mkAliasOptionModule sets the priority correctly
# for aliased options.
#
# This test shows that an alias with a high priority is able to override
# a non-aliased option.

{ config, lib, ... }:

let
  inherit (lib)
    mkAliasOptionModule
    mkForce
    mkOption
    types
    ;
in

{
  options = {
    # A simple boolean option that can be enabled or disabled.
    enable = mkOption {
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
      default = [ ];
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
    (mkAliasOptionModule [ "enableAlias" ] [ "enable" ])

    # Disable the aliased option with a high priority so it
    # should override the next import.
    (
      { config, lib, ... }:
      {
        enableAlias = mkForce false;
      }
    )

    # Enable the normal (non-aliased) option.
    (
      { config, lib, ... }:
      {
        enable = true;
      }
    )
  ];
}
