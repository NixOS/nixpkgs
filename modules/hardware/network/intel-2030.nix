{pkgs, config, ...}:

{
  hardware.firmware = [ pkgs.iwlwifi2030ucode ];
}
