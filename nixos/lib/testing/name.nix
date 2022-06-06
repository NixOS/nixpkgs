{ lib, ... }:
{
  options.name = lib.mkOption {
    description = "The name of the test.";
    type = lib.types.str;
  };
}
