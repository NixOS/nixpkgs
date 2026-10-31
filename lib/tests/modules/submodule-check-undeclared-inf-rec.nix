{ lib, config, ... }:
{
  options.module = lib.mkOption {
    type = lib.types.submodule [
      {
        options.foo = lib.mkOption {
          type = lib.types.str;
          default = "foo";
        };
      }
    ];
  };

  # If the definition value was used in the undeclared option error,
  # it'd result in infinite recursion, because the value itself requires
  # `config.module`, which is where that error is thrown.
  # https://github.com/NixOS/nixpkgs/pull/569232
  config.module.doesnt_exist = config.module.foo;
}
