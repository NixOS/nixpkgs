{pkgs, config, ...}:

{
  hardware.firmware = [ pkgs.iwlwifi5000ucode ];
}
