{ config, pkgs, ... }:

with pkgs.lib;

{

  options.services.hardware.pommed = {
    enable = mkOption {
      default = false;
       description = ''
        Whether to use the pommed tool to handle Apple laptop keyboard hotkeys.
      '';
    };

    configFile = mkOption {
      default = "${pkgs.pommed}/etc/pommed.conf";
      description = ''
        The contents of the pommed.conf file.
      '';
    };
  };

  config = mkIf config.services.hardware.pommed.enable {
    environment.systemPackages = [ pkgs.polkit ];

    environment.etc = [
      { source = config.services.hardware.pommed.configFile;
        target = "pommed.conf";
      }
    ];

    services.dbus.packages = [ pkgs.pommed ];

    jobs.pommed = { name = "pommed";

      description = "Pommed hotkey management";

      startOn = "started dbus";

      postStop = "rm -f /var/run/pommed.pid";

      exec = "${pkgs.pommed}/bin/pommed";

      daemonType = "fork";

      path = [ pkgs.eject ];
    };
  };
}
