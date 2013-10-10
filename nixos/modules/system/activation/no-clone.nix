# This configuration is not made to figure inside the module-list.nix to
# allow clone of the first level.
{pkgs, ...}:

with pkgs.lib;

{
  boot.loader.grub.device = mkOverrideTemplate 0 {} "nodev";
  nesting.children = mkOverrideTemplate 0 {} [];
  nesting.clone = mkOverrideTemplate 0 {} [];
}
