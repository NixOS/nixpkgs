{ lib, ... }:
let
  inherit (lib) types mkOption;

  inherit (types)
    # attrsOf uses attrsWith internally
    attrsOf
    listOf
    unique
    nullOr
    functionTo
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
        # unique
        options.unique = mkOption {
          type = unique { message = ""; } (listOf types.str);
        };
        options.mergedUnique = mkOption {
          type = unique { message = ""; } (listOf types.str);
        };
        # nullOr
        options.nullOr = mkOption {
          type = nullOr (listOf types.str);
        };
        options.mergedNullOr = mkOption {
          type = nullOr (listOf types.str);
        };
        # nullOr
        options.functionTo = mkOption {
          type = functionTo (listOf types.str);
        };
        options.mergedFunctionTo = mkOption {
          type = functionTo (listOf types.str);
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
        options.mergedUnique = mkOption {
          type = unique { message = ""; } (listOf types.str);
        };
        options.mergedNullOr = mkOption {
          type = nullOr (listOf types.str);
        };
        options.mergedFunctionTo = mkOption {
          type = functionTo (listOf types.str);
        };
      }
    )
  ];
}
