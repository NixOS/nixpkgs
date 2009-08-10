{pkgs, config, ...}:

{
  hardware.firmware = [ config.boot.kernelPackages.iwlwifi4965ucode ];
}
