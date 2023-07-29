# This is a test to show that mkAliasOptionModule sets the priority correctly
# for aliased options.
#
# This test shows that an alias with a high priority is able to override
# a non-aliased option.

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
  };

  imports = [
    # mkAliasOptionModule sets warnings, so this has to be imported.
    ./dummy-warnings-module.nix

    # Create an alias for the "enable" option.
    (mkAliasOptionModule [ "enableAlias" ] [ "enable" ])

    # Disable the aliased option with a high priority so it
    # should override the next import.
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
