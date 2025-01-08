{ lib, ... }:

{
  boot.loader.grub.device = lib.mkOverride 0 "nodev";
  specialisation = lib.mkOverride 0 { };
  isSpecialisation = lib.mkOverride 0 true;
}
