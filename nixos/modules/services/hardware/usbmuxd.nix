{ config, lib, pkgs, ... }:

with lib;

{
  options.services.usbmuxd.enable = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Enable the usbmuxd ("USB multiplexing daemon") service. This daemon is in
      charge of multiplexing connections over USB to an iOS device. This is
      needed for transferring data from and to iOS devices (see ifuse). Also
      this may enable plug-n-play tethering for iPhones.
    '';
  };

  config = mkIf config.services.usbmuxd.enable {
    systemd.services.usbmuxd = {
      description = "usbmuxd";
      wantedBy = [ "multi-user.target" ];
      unitConfig.Documentation = "man:usbmuxd(8)";
      serviceConfig.ExecStart = "${pkgs.usbmuxd}/bin/usbmuxd -f";
    };
  };
}
