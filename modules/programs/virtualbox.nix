{ config, pkgs, ... }:

with pkgs.lib;

let virtualbox = config.boot.kernelPackages.virtualbox; in

{
  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" ];
  boot.extraModulePackages = [ virtualbox ];
  environment.systemPackages = [ virtualbox ];

  users.extraGroups = singleton { name = "vboxusers"; };

  services.udev.extraRules =
    ''
      KERNEL=="vboxdrv",    OWNER="root", GROUP="vboxusers", MODE="0660", TAG+="systemd"
      KERNEL=="vboxnetctl", OWNER="root", GROUP="root",      MODE="0600", TAG+="systemd"
    '';

  # Since we lack the right setuid binaries, set up a host-only network by default.

  jobs."vboxnet0" =
    { description = "VirtualBox vboxnet0 Interface";
      requires = [ "dev-vboxnetctl.device" ];
      after = [ "dev-vboxnetctl.device" ];
      wantedBy = [ "network.target" "sys-subsystem-net-devices-vboxnet0.device" ];
      path = [ virtualbox ];
      preStart =
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

  networking.interfaces.vboxnet0 = { ipAddress = "192.168.56.1"; prefixLength = 24; };
}
