{ lib, ... }:
let
  inherit (lib) types mkOption;

  inherit (types)
    # attrsOf uses attrsWith internally
    attrsOf
    listOf
    ;
in
{
  imports = [
    #  Module A
    (
      { ... }:
      {
        options.attrsWith = mkOption {
          type = attrsOf (listOf types.str);
        };
        options.mergedAttrsWith = mkOption {
          type = attrsOf (listOf types.str);
        };
        options.listOf = mkOption {
          type = listOf (listOf types.str);
        };
        options.mergedListOf = mkOption {
          type = listOf (listOf types.str);
        };
      }
    )
    # Module B
    (
      { ... }:
      {
        options.mergedAttrsWith = mkOption {
          type = attrsOf (listOf types.str);
        };
        options.mergedListOf = mkOption {
          type = listOf (listOf types.str);
        };
      }
    )
  ];
}
