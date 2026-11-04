{ lib, ... }:
{
  imports = [ ../sub.nix ];
  options.subsub = lib.mkOption { default = true; };
}
