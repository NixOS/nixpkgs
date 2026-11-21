{ lib, ... }:
{
  imports = [ ../prog.nix ];
  options.sub = lib.mkOption { default = true; };
}
