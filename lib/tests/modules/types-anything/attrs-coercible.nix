{ lib, ... }:
{

  options.value = lib.mkOption {
    type = lib.types.anything;
  };

  config.value = {
    outPath = "foo";
    err = throw "err";
  };

}
