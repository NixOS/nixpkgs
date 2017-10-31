{pkgs, config, ...}:

{
  hardware.firmware = [ pkgs.zd1211fw ];
}
