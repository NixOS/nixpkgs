{ lib, ... }:
{
  options.foo = lib.mkOption {
    default = { };
    type =
      lib.extendSubmodule
        {
          boo.bar.default = "baz";
        }
        (
          lib.types.submodule {
            options.boo = lib.mkOption {
              default = { };
              type = lib.types.submodule {
                options.bar = lib.mkOption { type = lib.types.int; };
              };
            };
          }
        );
  };
}
