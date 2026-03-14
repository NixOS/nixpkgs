{ lib, ... }:
{
  options.foo =
    lib.modules.extendOption
      {
        bar.default = "baz";
      }
      (
        lib.mkOption {
          default = { };
          type = lib.types.submodule {
            options.bar = lib.mkOption { type = lib.types.int; };
          };
        }
      );
}
