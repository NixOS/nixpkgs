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
            placeholder = "id"; # <- this is beeing tested
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
            placeholder = "other"; # <- define placeholder = "other" (conflict)
            elemType = types.submodule { };
          };
        };
      }
    )
  ];
}
