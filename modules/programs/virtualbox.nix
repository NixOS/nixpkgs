{ config, pkgs, ... }:

with pkgs.lib;

let virtualbox = config.boot.kernelPackages.virtualbox; in

{
  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" ];
  boot.extraModulePackages = [ virtualbox ];
  environment.systemPackages = [ virtualbox ];

  # ‘VBoxNetAdpCtl’ needs to be setuid root to allow users to create
  # host-only networks (https://www.virtualbox.org/ticket/4014).
  security.setuidOwners = singleton
    { program = "VBoxNetAdpCtl";
      source = "${virtualbox}/virtualbox/VBoxNetAdpCtl";
      owner = "root";
      group = "root";
      setuid = true;
    };
}
