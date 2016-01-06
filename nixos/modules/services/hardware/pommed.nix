{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    services.hardware.pommed = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to use the pommed tool to handle Apple laptop keyboard hotkeys.
        '';
      };

      configFile = mkOption {
        type = types.path;
        description = ''
          The path to the <filename>pommed.conf</filename> file.
        '';
      };
    };

  };

  config = mkIf config.services.hardware.pommed.enable {
    environment.systemPackages = [ pkgs.polkit ];

    environment.etc."pommed.conf".source = config.services.hardware.pommed.configFile;

    services.hardware.pommed.configFile = "${pkgs.pommed}/etc/pommed.conf";

    services.dbus.packages = [ pkgs.pommed ];

    systemd.services.pommed = {
      description = "Pommed hotkey management";
      wantedBy = [ "multi-user.target" ];
      after = [ "dbus.service" ];
      postStop = "rm -f /var/run/pommed.pid";
      script = "${pkgs.pommed}/bin/pommed";
      serviceConfig.Type = "forking";
      path = [ pkgs.eject ];
    };
  };
}
