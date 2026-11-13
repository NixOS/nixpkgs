{ lib, ... }:
{
  options.value = lib.mkOption {
    type = lib.types.package;
  };

  config.value = {
    a = 1;
    b = 2;
    c = 3;
    d = 4;
    e = 5;
    f = 6;
    g = 7;
    h = 8;
    i = throw "This omitted attribute must not be evaluated";
  };
}
