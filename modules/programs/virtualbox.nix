{ config, pkgs, ... }:

with pkgs.lib;

{
  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.virtualbox ];
  environment.systemPackages = [ pkgs.linuxPackages.virtualbox ];

  # ‘VBoxNetAdpCtl’ needs to be setuid root to allow users to create
  # host-only networks (https://www.virtualbox.org/ticket/4014).
  security.setuidOwners = singleton
    { program = "VBoxNetAdpCtl";
      source = "${pkgs.linuxPackages.virtualbox}/virtualbox/VBoxNetAdpCtl";
      owner = "root";
      group = "root";
      setuid = true;
    };
}
