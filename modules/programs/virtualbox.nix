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
      KERNEL=="vboxdrv",    OWNER="root", GROUP="vboxusers", MODE="0660"
      KERNEL=="vboxnetctl", OWNER="root", GROUP="root",      MODE="0600"
    '';

  # Since we lack the right setuid binaries, set up a host-only network by default.
  
  jobs."create-vboxnet0" =
    { task = true;
      path = [ virtualbox ];
      startOn = "starting network-interfaces";
      script =
        ''
          if ! [ -e /sys/class/net/vboxnet0 ]; then
            VBoxManage hostonlyif create
          fi
        '';
    };

  networking.interfaces = [ { name = "vboxnet0"; ipAddress = "192.168.56.1"; } ];
}
