{ lib, ... }:

{
  options = {
    value = lib.mkOption {
      default = 42;
      type = lib.types.coercedTo lib.types.int toString lib.types.str;
    };
  };
}
