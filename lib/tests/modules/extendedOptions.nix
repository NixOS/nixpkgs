{ lib, ... }:
{
  options.foo = lib.mkOption {
    default = { };
    type =
      lib.modules.extendedOptions
        {
          bar = lib.mkOption { type = lib.types.int; };
        }
        {
          bar.default = "baz";
        };
  };
}
