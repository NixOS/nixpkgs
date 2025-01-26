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
            placeholder = "id"; # <- This is beeing tested
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
        # defines the default placeholder "name"
        # type merging should resolve to "id"
        options.mergedName = mkOption {
          type = types.attrsOf (types.submodule { });
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
