{ lib, pkgs, ... }:

{
  imports = [ ../../. ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.opengl.driSupport32Bit = true;

  services.xserver = {
    libinput.enable = lib.mkDefault true;

    # TODO: we should not enable unfree drivers
    # when there is an alternative (i.e. nouveau)
    videoDrivers = [ "nvidia" ];
  };
}
