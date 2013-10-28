{pkgs, ...}:

with pkgs.lib;

{
  boot.loader.grub.device = mkOverride 0 "nodev";
  nesting.children = mkOverride 0 [];
  nesting.clone = mkOverride 0 [];
}
