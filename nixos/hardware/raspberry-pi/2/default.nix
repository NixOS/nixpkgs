{ lib, pkgs, ...}:

{
  boot = {
    consoleLogLevel = lib.mkDefault 7;
    extraTTYs = [ "ttyAMA0" ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi2;
    kernelParams = [
      "dwc_otg.lpm_enable=0"
      "console=ttyAMA0,115200"
      "rootwait"
      "elevator=deadline"
    ];
    loader = {
      grub.enable = lib.mkDefault false;
      generationsDir.enable = lib.mkDefault false;
      raspberryPi = {
        enable = lib.mkDefault true;
	version = lib.mkDefault 2;
      };
    };
  };

  nix.buildCores = 4;

  nixpkgs.config.platform = lib.systems.platforms.raspberrypi2;

  # cpufrequtils doesn't build on ARM
  powerManagement.enable = lib.mkDefault false;

  services.openssh.enable = lib.mkDefault true;
}
