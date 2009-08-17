{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    environment.systemPackages = [ pkgs.console_kit ];

    services.dbus.packages = [ pkgs.console_kit ];

    environment.etc = singleton
      { source = (pkgs.buildEnv {
          name = "console-kit-config";
          pathsToLink = [ "/etc/ConsoleKit" ];
          paths = [ pkgs.console_kit pkgs.udev ];
        }) + "/etc/ConsoleKit";
        target = "ConsoleKit";
      };

  };

}
