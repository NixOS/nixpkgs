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

  # hard disk protection if the laptop falls
  services.hdapsd.enable = true;

  # trackpoint support (touchpad disabled in this config)
  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;

  # alternatively, touchpad with two-finger scrolling
  #services.xserver.libinput.enable = true;

  # enable volume control buttons
  sound.enableMediaKeys = true;

  # fingerprint reader: login and unlock with fingerprint (if you add one with `fprintd-enroll`)
  #services.fprintd.enable = true;
  #security.pam.services.login.fprintAuth = true;
  #security.pam.services.xscreensaver.fprintAuth = true;
  # similarly for other PAM providers
}
