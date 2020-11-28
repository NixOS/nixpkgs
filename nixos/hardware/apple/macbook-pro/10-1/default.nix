{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
  ];

  # TODO: boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # TODO: reverse compat
  hardware.opengl.driSupport32Bit = true;

  services.xserver = {
    # TODO: we should not enable unfree drivers
    # when there is an alternative (i.e. nouveau)
    videoDrivers = [ "nvidia" ];
  };
}
