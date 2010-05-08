# This configuration is not made to figure inside the module-list.nix to
# allow clone of the first level.
{pkgs, ...}:

with pkgs.lib;

{
  boot.loader.grub.device = mkOverride 0 {} "";
  # undefined the obsolete name of the previous option.
  boot.grubDevice = mkOverride 0 {} pkgs.lib.mkNotdef;
  nesting.children = mkOverride 0 {} [];
  nesting.clone = mkOverride 0 {} [];
}
