{ lib, ... }:
{
  options.image.builder = lib.mkOption {
    type = lib.types.raw;
    description = "Derivation to build a disk image";
  };
}
