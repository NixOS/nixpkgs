{ lib, ... }:
{
  options.image.builderAttr = lib.mkOption {
    type = lib.types.str;
    description = "Declare the default attribute to build";
  };
}
