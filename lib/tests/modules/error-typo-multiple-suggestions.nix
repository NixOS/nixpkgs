{ lib, ... }:

{
  options.foo = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  options.bar = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  options.baz = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = {
    far = true;
  };
}
