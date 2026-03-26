{ lib, ... }:
{
  options.foo = lib.mkOption {
    type = lib.types.submodule { };
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
