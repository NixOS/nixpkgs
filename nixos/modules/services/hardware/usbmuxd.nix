{ config, lib, pkgs, ... }:

with lib;

let

  defaultUserGroup = "usbmux";
  apple = "05ac";

  cfg = config.services.usbmuxd;

in

{
  options.services.usbmuxd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the usbmuxd ("USB multiplexing daemon") service. This daemon is
        in charge of multiplexing connections over USB to an iOS device. This is
        needed for transferring data from and to iOS devices (see ifuse). Also
        this may enable plug-n-play tethering for iPhones.
      '';
    };

    user = mkOption {
      type = types.str;
      default = defaultUserGroup;
      description = ''
        The user usbmuxd should use to run after startup.
      '';
    };

    group = mkOption {
      type = types.str;
      default = defaultUserGroup;
      description = ''
        The group usbmuxd should use to run after startup.
      '';
    };
  };

  config = mkIf cfg.enable {

    users.users = optionalAttrs (cfg.user == defaultUserGroup) {
      ${cfg.user} = {
        description = "usbmuxd user";
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == defaultUserGroup) {
      ${cfg.group} = { };
    };

    # Give usbmuxd permission for Apple devices
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="${apple}", GROUP="${cfg.group}"
    '';

    systemd.services.usbmuxd = {
      description = "usbmuxd";
      wantedBy = [ "multi-user.target" ];
      unitConfig.Documentation = "man:usbmuxd(8)";
      serviceConfig = {
        # Trigger the udev rule manually. This doesn't require replugging the
        # device when first enabling the option to get it to work
        ExecStartPre = "${pkgs.udev}/bin/udevadm trigger -s usb -a idVendor=${apple}";
        ExecStart = "${pkgs.usbmuxd}/bin/usbmuxd -U ${cfg.user} -f";
      };
    };

  };
}
