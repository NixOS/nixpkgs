{ config, pkgs, ... }:

{

  ###### implementation

  config = {

    jobs.lvm =
      { startOn = "started udev or new-devices";

        script =
          ''
            # Make all logical volumes on all volume groups available, i.e.,
            # make them appear in /dev.
            ${pkgs.lvm2}/sbin/vgchange --available y
          '';

        task = true;
      };

    environment.systemPackages = [ pkgs.lvm2 ];

    services.udev.packages = [ pkgs.lvm2 ];

  };

}
