# Check that AttrsWith { lazy = true; } is lazy
{ lib, ... }:
let
  inherit (lib) types mkOption;

  lazyAttrsOf = mkOption {
    # Same as lazyAttrsOf
    type = types.attrsWith {
      lazy = true;
      elemType = types.int;
    };
  };

  attrsOf = mkOption {
    # Same as lazyAttrsOf
    type = types.attrsWith {
      elemType = types.int;
    };
  };
in
{
  imports = [
    #  Module A
    (
      { ... }:
      {
        options.mergedLazyLazy = lazyAttrsOf;
        options.mergedLazyNonLazy = lazyAttrsOf;
        options.mergedNonLazyNonLazy = attrsOf;
      }
    )
    # Module B
    (
      { ... }:
      {
        options.mergedLazyLazy = lazyAttrsOf;
        options.mergedLazyNonLazy = attrsOf;
        options.mergedNonLazyNonLazy = attrsOf;
      }
    )
    # Result
    (
      { config, ... }:
      {
        # Can only evaluate if lazy
        config.mergedLazyLazy.bar = config.mergedLazyLazy.baz + 1;
        config.mergedLazyLazy.baz = 10;
        options.lazyResult = mkOption { default = config.mergedLazyLazy.bar; };

        # Can not only evaluate if not lazy
        config.mergedNonLazyNonLazy.bar = config.mergedNonLazyNonLazy.baz + 1;
        config.mergedNonLazyNonLazy.baz = 10;
        options.nonLazyResult = mkOption { default = config.mergedNonLazyNonLazy.bar; };
      }
    )
  ];
}
