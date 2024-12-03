# Check that AttrsWith { lazy = true; } is lazy
{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  imports = [
    # Module A
    (
      { ... }:
      {
        options.mergedName = mkOption {
          default = { };
          type = types.attrsWith {
            # Declare <name> = "id"
            name = "id";
            elemType = types.submodule {
              options.nested = mkOption {
                type = types.int;
                default = 1;
              };
            };
          };
        };
      }
    )
    # Module B
    (
      { ... }:
      {
        options.mergedName = mkOption {
          # default: "<name>"
          type = types.attrsOf (types.submodule { });
          # default = {};
        };
      }
    )

    # Output
    (
      {
        options,
        ...
      }:
      {
        options.result = mkOption {
          default = lib.concatStringsSep "." (options.mergedName.type.getSubOptions options.mergedName.loc)
          .nested.loc;
        };
      }
    )
  ];
}
