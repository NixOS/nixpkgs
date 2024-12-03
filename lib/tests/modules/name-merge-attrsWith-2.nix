# Non mergable attrsWith
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
          type = types.attrsWith {
            name = "other";
            elemType = types.submodule { };
          };
        };
      }
    )
  ];
}
