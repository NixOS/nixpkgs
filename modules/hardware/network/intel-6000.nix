{pkgs, config, ...}:

{
  hardware.firmware = [ pkgs.iwlwifi6000ucode ];
}
