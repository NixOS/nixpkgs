{ config, pkgs, ... }:

{

  ###### implementation

  config = {

    jobs.lvm =
      { startOn = "started udev or new-devices";

        script =
          ''
            # Scan for block devices that might contain LVM physical volumes
            # and volume groups.
            ${pkgs.lvm2}/sbin/vgscan

            # Make all logical volumes on all volume groups available, i.e.,
            # make them appear in /dev.
            ${pkgs.lvm2}/sbin/vgchange --available y

            initctl emit -n new-devices
          '';

        task = true;
      };

    environment.systemPackages = [ pkgs.lvm2 ];

    services.udev.packages = [ pkgs.lvm2 ];

  };
  
}
