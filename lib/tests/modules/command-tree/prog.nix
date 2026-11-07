{ lib, ... }:
{
  options.package = lib.mkOption { type = lib.types.package; };
  options.prog = lib.mkOption { default = true; };
}
