{pkgs, config, ...}:

with pkgs.lib;

{

  ###### interface

  options = {
  
  };


  ###### implementation
  
  config = {

    jobs = pkgs.lib.singleton
      { name = "bluetoothd";

        startOn = "dbus/started";
        stopOn = "dbus/stop";

        preStart =
          ''
            mkdir -m 0755 -p /var/lib/bluetooth
          '';

        exec = "${pkgs.bluez}/sbin/bluetoothd --nodaemon --debug";
      };

    environment.systemPackages = [pkgs.bluez pkgs.openobex pkgs.obexftp];

    services.dbus.enable = true;
    services.dbus.packages = [pkgs.bluez];
  };  
  
}
