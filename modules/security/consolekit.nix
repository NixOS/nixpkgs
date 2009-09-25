{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    environment.systemPackages = [ pkgs.consolekit ];

    services.dbus.packages = [ pkgs.consolekit ];

    environment.etc = singleton
      { source = (pkgs.buildEnv {
          name = "consolekit-config";
          pathsToLink = [ "/etc/ConsoleKit" ];
          paths = [ pkgs.consolekit pkgs.udev ];
        }) + "/etc/ConsoleKit";
        target = "ConsoleKit";
      };

  };

}
