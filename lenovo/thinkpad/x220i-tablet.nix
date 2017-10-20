{ config, pkgs, ... }:

{
  imports = [ ./general-intel.nix ];

  # TPM chip countains a RNG
  security.rngd.enable = true;

  boot = {
    kernelModules = [ "tp_smapi" ];
    extraModulePackages = [ config.boot.kernelPackages.tp_smapi ];
  };

  # hard disk protection if the laptop falls
  services.hdapsd.enable = true;

  # fingerprint reader: login and unlock with fingerprint (if you add one with `fprintd-enroll`)
  #services.fprintd.enable = true;
  #security.pam.services.login.fprintAuth = true;
  #security.pam.services.xscreensaver.fprintAuth = true;
  # similarly for other PAM providers
}
