{ config, lib, pkgs, ... }:

with lib;

let
  virtualbox = config.boot.kernelPackages.virtualbox;
in

{
  options = {
    services.virtualboxHost.enable = mkEnableOption "VirtualBox Host support";
    services.virtualboxHost.addNetworkInterface = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically set up a vboxnet0 host-only network interface.";
    };
  };

  config = mkIf config.services.virtualboxHost.enable {
    boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" ];
    boot.extraModulePackages = [ virtualbox ];
    environment.systemPackages = [ virtualbox ];

    security.setuidOwners = let
      mkVboxStub = program: {
        inherit program;
        owner = "root";
        group = "vboxusers";
        setuid = true;
      };
    in map mkVboxStub [
      "VBoxBFE"
      "VBoxBalloonCtrl"
      "VBoxHeadless"
      "VBoxManage"
      "VBoxSDL"
      "VirtualBox"
    ];

    users.extraGroups.vboxusers.gid = config.ids.gids.vboxusers;

    services.udev.extraRules =
      ''
        KERNEL=="vboxdrv",    OWNER="root", GROUP="vboxusers", MODE="0660", TAG+="systemd"
        KERNEL=="vboxdrvu",   OWNER="root", GROUP="root",      MODE="0666", TAG+="systemd"
        KERNEL=="vboxnetctl", OWNER="root", GROUP="vboxusers", MODE="0660", TAG+="systemd"
        SUBSYSTEM=="usb_device", ACTION=="add", RUN+="${virtualbox}/libexec/virtualbox/VBoxCreateUSBNode.sh $major $minor $attr{bDeviceClass}"
        SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", RUN+="${virtualbox}/libexec/virtualbox/VBoxCreateUSBNode.sh $major $minor $attr{bDeviceClass}"
        SUBSYSTEM=="usb_device", ACTION=="remove", RUN+="${virtualbox}/libexec/virtualbox/VBoxCreateUSBNode.sh --remove $major $minor"
        SUBSYSTEM=="usb", ACTION=="remove", ENV{DEVTYPE}=="usb_device", RUN+="${virtualbox}/libexec/virtualbox/VBoxCreateUSBNode.sh --remove $major $minor"
      '';

    # Since we lack the right setuid binaries, set up a host-only network by default.
  } // mkIf config.services.virtualboxHost.addNetworkInterface {
    systemd.services."vboxnet0" =
      { description = "VirtualBox vboxnet0 Interface";
        requires = [ "dev-vboxnetctl.device" ];
        after = [ "dev-vboxnetctl.device" ];
        wantedBy = [ "network.target" "sys-subsystem-net-devices-vboxnet0.device" ];
        path = [ virtualbox ];
        serviceConfig.RemainAfterExit = true;
        serviceConfig.Type = "oneshot";
        script =
          ''
            if ! [ -e /sys/class/net/vboxnet0 ]; then
              VBoxManage hostonlyif create
            fi
          '';
        postStop =
          ''
            VBoxManage hostonlyif remove vboxnet0
          '';
      };

    networking.interfaces.vboxnet0.ip4 = [ { address = "192.168.56.1"; prefixLength = 24; } ];
  };
}
