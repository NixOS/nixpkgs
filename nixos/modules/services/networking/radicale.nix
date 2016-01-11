{config, lib, pkgs, ...}:

with lib;

let

  cfg = config.services.radicale;

  confFile = pkgs.writeText "radicale.conf" cfg.config;

in

{

  options = {

    services.radicale.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Enable Radicale CalDAV and CardDAV server
      '';
    };

    services.radicale.config = mkOption {
      type = types.string;
      default = "";
      description = ''
        Radicale configuration, this will set the service
        configuration file
      '';
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pythonPackages.radicale ];

    systemd.services.radicale = {
      description = "A Simple Calendar and Contact Server";
      after = [ "network-interfaces.target" ];
      wantedBy = [ "multi-user.target" ];
      script = "${pkgs.pythonPackages.radicale}/bin/radicale -C ${confFile} -d";
      serviceConfig.Type = "forking";
    };
  };
}
