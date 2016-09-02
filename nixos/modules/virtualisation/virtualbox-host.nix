{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.virtualbox.host;
  virtualbox = config.boot.kernelPackages.virtualbox.override {
    inherit (cfg) enableHardening headless;
  };

in

{
  options.virtualisation.virtualbox.host = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable VirtualBox.

        <note><para>
          In order to pass USB devices from the host to the guests, the user
          needs to be in the <literal>vboxusers</literal> group.
        </para></note>
      '';
    };

    addNetworkInterface = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Automatically set up a vboxnet0 host-only network interface.
      '';
    };

    enableHardening = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable hardened VirtualBox, which ensures that only the binaries in the
        system path get access to the devices exposed by the kernel modules
        instead of all users in the vboxusers group.

        <important><para>
          Disabling this can put your system's security at risk, as local users
          in the vboxusers group can tamper with the VirtualBox device files.
        </para></important>
      '';
    };

    headless = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Use VirtualBox installation without GUI and Qt dependency. Useful to enable on servers
        and when virtual machines are controlled only via SSH.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" ];
    boot.extraModulePackages = [ virtualbox ];
    environment.systemPackages = [ virtualbox ];

    security.setuidOwners = let
      mkSuid = program: {
        inherit program;
        source = "${virtualbox}/libexec/virtualbox/${program}";
        owner = "root";
        group = "vboxusers";
        setuid = true;
      };
    in mkIf cfg.enableHardening (map mkSuid [
      "VBoxHeadless"
      "VBoxNetAdpCtl"
      "VBoxNetDHCP"
      "VBoxNetNAT"
      "VBoxSDL"
      "VBoxVolInfo"
      "VirtualBox"
    ]);

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
  } (mkIf cfg.addNetworkInterface {
    systemd.services."vboxnet0" =
      { description = "VirtualBox vboxnet0 Interface";
        requires = [ "dev-vboxnetctl.device" ];
        after = [ "dev-vboxnetctl.device" ];
        wantedBy = [ "network.target" "sys-subsystem-net-devices-vboxnet0.device" ];
        path = [ virtualbox ];
        serviceConfig.RemainAfterExit = true;
        serviceConfig.Type = "oneshot";
        serviceConfig.PrivateTmp = true;
        environment.VBOX_USER_HOME = "/tmp";
        script =
          ''
            if ! [ -e /sys/class/net/vboxnet0 ]; then
              VBoxManage hostonlyif create
              cat /tmp/VBoxSVC.log >&2
            fi
          '';
        postStop =
          ''
            VBoxManage hostonlyif remove vboxnet0
          '';
      };

    networking.interfaces.vboxnet0.ip4 = [ { address = "192.168.56.1"; prefixLength = 24; } ];
    # Make sure NetworkManager won't assume this interface being up
    # means we have internet access.
    networking.networkmanager.unmanaged = ["vboxnet0"];
  })]);
}
