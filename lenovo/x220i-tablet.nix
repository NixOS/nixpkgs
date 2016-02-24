{ config, pkgs, ... }:

{
  # TPM chip countains a RNG
  security.rngd.enable = true;

  boot = {
    kernelModules = [ "tp_smapi" ];
    extraModulePackages = [ config.boot.kernelPackages.tp_smapi ];
  };

  # TLP Linux Advanced Power Management
  services.tlp.enable = true;
}
