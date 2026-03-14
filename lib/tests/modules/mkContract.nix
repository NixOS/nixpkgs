{ lib, ... }:
{
  options.foo = lib.mkOption {
    default = { };
    type =
      lib.modules.mkContract
        {
          bar = lib.mkOption { type = lib.types.int; };
        }
        {
          bar.default = "baz";
        };
  };
}
