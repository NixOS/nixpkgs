# This is a test to show that mkAliasOptionModule sets the location correctly
# for aliased definitions.

{ lib, ... }:

let
  inherit (lib)
    mkAliasOptionModule
    mkOption
    setDefaultModuleLocation
    types
    ;
in

{
  # A simple option that can merge multiple str definitions
  options.lines = mkOption {
    type = types.lines;
    default = "";
    description = ''
      Some descriptive text
    '';
  };

  imports = [
    # Create an alias for the "lines" option.
    (mkAliasOptionModule [ "linesAlias" ] [ "lines" ])

    # Define the aliased option.
    (setDefaultModuleLocation "alias-defs" {
      linesAlias = "world";
    })

    # Define the normal (non-aliased) option.
    (setDefaultModuleLocation "main-defs" {
      lines = "hello";
    })
  ];
}
