{ lib, ... }:

{
  options = {
    value = lib.mkOption {
      default = 42;
      type = lib.types.postTransform builtins.toString lib.types.int;
    };
  };
}
