{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.rtl-sdr;

in {
  options.hardware.rtl-sdr = {
    enable = lib.mkEnableOption ''
      Enables rtl-sdr udev rules and ensures 'plugdev' group exists.
      This is a prerequisite to using devices supported by rtl-sdr without
      being root, since rtl-sdr USB descriptors will be owned by plugdev
      through udev.
    '';
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.rtl-sdr ];
    users.groups.plugdev = {};
  };
}
