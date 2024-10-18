# Check that AttrsWith { lazy = true; } is lazy
{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  imports = [
    #  Module A
    (
      { ... }:
      {
        options.mergedLazy = mkOption {
          # Same as lazyAttrsOf
          type = types.attrsWith {
            lazy = true;
            elemType = types.int;
          };
        };
      }
    )
    # Module B
    (
      { ... }:
      {
        options.mergedLazy = lib.mkOption {
          # Same as lazyAttrsOf
          type = types.attrsWith {
            lazy = true;
            elemType = types.int;
          };
        };
      }
    )
    # Result
    (
      { config, ... }:
      {
        # Can only evaluate if lazy
        config.mergedLazy.bar = config.mergedLazy.baz + 1;
        config.mergedLazy.baz = 10;
        options.result = mkOption { default = config.mergedLazy.bar; };
      }
    )
  ];
}
