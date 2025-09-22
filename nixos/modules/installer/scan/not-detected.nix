# Enables non-free firmware on devices not recognized by `nixos-generate-config`.
{ lib, ... }:

{
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
