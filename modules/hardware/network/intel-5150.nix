{pkgs, config, ...}:

{
  hardware.firmware = [ pkgs.iwlwifi5150ucode ];
}
