{ _class, lib, ... }:
{
  options = {
    foo = lib.mkOption {
      default = _class;
    };
  };
}
