{ lib, ... }:

{
  options = {
    value = lib.mkOption {
      type = lib.types.coercedTo lib.types.int toString lib.types.str;
    };
  };
}
