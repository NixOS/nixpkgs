# This configuration is not made to figure inside the module-list.nix to
# allow clone of the first level.
{pkgs, ...}:

with pkgs.lib;

{
  boot.loader.grub.device = mkOverrideTemplate 0 {} "";
  # undefine the obsolete name of the previous option.
  boot.grubDevice = mkOverrideTemplate 0 {} pkgs.lib.mkNotdef;
  boot.loader.grub.ignoreDevicesCheck = mkOverrideTemplate 0 {} true;
  nesting.children = mkOverrideTemplate 0 {} [];
  nesting.clone = mkOverrideTemplate 0 {} [];
}
