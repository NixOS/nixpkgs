{ lib, ... }:

with lib;

{
  boot.loader.grub.device = mkOverride 0 "nodev";
  specialisation = mkOverride 0 { };
}
