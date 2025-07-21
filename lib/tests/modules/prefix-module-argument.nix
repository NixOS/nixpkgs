{ lib, ... }:
{
  options.foo = lib.mkOption {
    type = lib.types.submodule { };
    default = { };
  };

  config = {
    foo =
      { _prefix, ... }:
      assert _prefix == [ "foo" ];
      {
        options.ok = lib.mkOption { };
        config.ok = true;
      };
  };
}
