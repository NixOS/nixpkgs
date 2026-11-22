{ lib, ... }:
let
  inherit (lib) types mkOption;

  inherit (types)
    # attrsOf uses attrsWith internally
    attrsOf
    listOf
    submoduleOf
    str
    ;
in
{
  imports = [
    (
      { options, ... }:
      {
        # Should have an empty valueMeta
        options.str = mkOption {
          type = str;
        };

        # Should have some valueMeta which is an attribute set of the nested valueMeta
        options.attrsOf = mkOption {
          type = attrsOf str;
          default = {
            foo = "foo";
            bar = "bar";
          };
        };
        options.attrsOfResult = mkOption {
          default = builtins.attrNames options.attrsOf.valueMeta.attrs;
        };

        # Should have some valueMeta which is the list of the nested valueMeta of types.str
        # [ {} {} ]
        options.listOf = mkOption {
          type = listOf str;
          default = [
            "foo"
            "bar"
          ];
        };
        options.listOfResult = mkOption {
          default = builtins.length options.listOf.valueMeta.list;
        };

        # Should have some valueMeta which is the submodule evaluation
        # { _module, options, config, ...}
        options.submoduleOf = mkOption {
          type = submoduleOf {
            options.str = mkOption {
              type = str;
            };
          };
        };
      }
    )
  ];
}
