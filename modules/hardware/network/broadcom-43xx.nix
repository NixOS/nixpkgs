{ config, pkgs, ... }:

{
  hardware.firmware = [ pkgs.bcm43xx ];
}
