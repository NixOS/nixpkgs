{ lib, ... }:
{
  options.foo = lib.mkOption {
    default = { };
    type =
      lib.modules.extendSubmodule
        {
          bar.default = "baz";
        }
        (
          lib.types.submodule {
            options.bar = lib.mkOption { type = lib.types.int; };
          }
        );
  };
}
