{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.rtl-sdr;

in {
  options.hardware.rtl-sdr = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables rtl-sdr udev rules, ensures 'plugdev' group exists, and blacklists DVB kernel modules.
        This is a prerequisite to using devices supported by rtl-sdr without being root, since rtl-sdr USB descriptors will be owned by plugdev through udev.
       '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" "e4000" "rtl2832" ];
    services.udev.packages = [ pkgs.rtl-sdr ];
    users.groups.plugdev = {};
  };
}
