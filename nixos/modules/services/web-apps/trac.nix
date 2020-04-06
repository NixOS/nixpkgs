{ config, lib, pkgs, ... }:

let
  cfg = config.services.trac;

  inherit (lib) mkEnableOption mkIf mkOption types;

in {

  options = {

    services.trac = {
      enable = mkEnableOption "Trac service";

      listen = {
        ip = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = ''
            IP address that Trac should listen on.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 8000;
          description = ''
            Listen port for Trac.
          '';
        };
      };

      dataDir = mkOption {
        default = "/var/lib/trac";
        type = types.path;
        description = ''
            The directory for storing the Trac data.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Trac.
        '';
      };
    };

  };

  config = mkIf cfg.enable {

    systemd.services.trac = {
      description = "Trac server";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = baseNameOf cfg.dataDir;
        ExecStart = ''
          ${pkgs.trac}/bin/tracd -s \
            -b ${toString cfg.listen.ip} \
            -p ${toString cfg.listen.port} \
            ${cfg.dataDir}
        '';
      };
      preStart = ''
        if [ ! -e ${cfg.dataDir}/VERSION ]; then
          ${pkgs.trac}/bin/trac-admin ${cfg.dataDir} initenv Trac "sqlite:db/trac.db"
        fi
      '';
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ];
    };

  };
}
