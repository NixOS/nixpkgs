{ lib, ... }:

{
  options = {
    value = lib.mkOption {
      type = lib.types.nestedAttrsOf lib.types.int;
      default = {
        a = 1;
        b = {
          c = 2;
          d.e = 3;
          f = "4";
        };
      };
    };
  };
}
