{ pkgs, ... }:

{
  hardware.firmware = [ pkgs.zd1211fw ];
}
