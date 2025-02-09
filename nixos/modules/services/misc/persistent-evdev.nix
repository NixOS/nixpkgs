{ config, lib, pkgs, ... }:

let
  cfg = config.services.persistent-evdev;
  settingsFormat = pkgs.formats.json {};

  configFile = settingsFormat.generate "persistent-evdev-config" {
    cache = "/var/cache/persistent-evdev";
    devices = lib.mapAttrs (virt: phys: "/dev/input/by-id/${phys}") cfg.devices;
  };
in
{
  options.services.persistent-evdev = {
    enable = lib.mkEnableOption (lib.mdDoc "virtual input devices that persist even if the backing device is hotplugged");

    devices = lib.mkOption {
      default = {};
      type = with lib.types; attrsOf str;
      description = lib.mdDoc ''
        A set of virtual proxy device labels with backing physical device ids.

        Physical devices should already exist in {file}`/dev/input/by-id/`.
        Proxy devices will be automatically given a `uinput-` prefix.

        See the [project page](https://github.com/aiberia/persistent-evdev#example-usage-with-libvirt)
        for example configuration of virtual devices with libvirt
        and remember to add `uinput-*` devices to the qemu
        `cgroup_device_acl` list (see [](#opt-virtualisation.libvirtd.qemu.verbatimConfig)).
      '';
      example = lib.literalExpression ''
        {
          persist-mouse0 = "usb-Logitech_G403_Prodigy_Gaming_Mouse_078738533531-event-if01";
          persist-mouse1 = "usb-Logitech_G403_Prodigy_Gaming_Mouse_078738533531-event-mouse";
          persist-mouse2 = "usb-Logitech_G403_Prodigy_Gaming_Mouse_078738533531-if01-event-kbd";
          persist-keyboard0 = "usb-Microsoft_Natural®_Ergonomic_Keyboard_4000-event-kbd";
          persist-keyboard1 = "usb-Microsoft_Natural®_Ergonomic_Keyboard_4000-if01-event-kbd";
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.persistent-evdev = {
      documentation = [ "https://github.com/aiberia/persistent-evdev/blob/master/README.md" ];
      description = "Persistent evdev proxy";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${pkgs.persistent-evdev}/bin/persistent-evdev.py ${configFile}";
        CacheDirectory = "persistent-evdev";
      };
    };

    services.udev.packages = [ pkgs.persistent-evdev ];
  };

  meta.maintainers = with lib.maintainers; [ lodi ];
}
