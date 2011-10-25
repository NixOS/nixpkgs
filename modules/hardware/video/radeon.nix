{ config, pkgs, ... }:

{
  hardware.firmware = [ pkgs.radeonR600 pkgs.radeonR700 pkgs.radeonJuniper ];
}
