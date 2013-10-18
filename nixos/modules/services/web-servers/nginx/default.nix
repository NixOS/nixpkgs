{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.nginx;
  nginx = pkgs.nginx.override { fullWebDAV = cfg.fullWebDAV; };
  configFile = pkgs.writeText "nginx.conf" ''
    user ${cfg.user} ${cfg.group};
    daemon off;
    ${cfg.config}
  '';
in

{
  options = {
    services.nginx = {
      enable = mkOption {
        default = false;
        description = "
          Enable the nginx Web Server.
        ";
      };

      config = mkOption {
        default = "events {}";
        description = "
          Verbatim nginx.conf configuration.
        ";
      };

      stateDir = mkOption {
        default = "/var/spool/nginx";
        description = "
          Directory holding all state for nginx to run.
        ";
      };

      user = mkOption {
        default = "nginx";
        description = "User account under which nginx runs.";
      };

      group = mkOption {
        default = "nginx";
        description = "Group account under which nginx runs.";
      };

      fullWebDAV = mkOption {
        default = false;
        description = "Compile in a third party module providing full WebDAV support";
      };
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ nginx ];

    # TODO: test user supplied config file pases syntax test

    systemd.services.nginx = {
      description = "Nginx Web Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ nginx ];
      preStart =
        ''
        mkdir -p ${cfg.stateDir}/logs
        chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir}
        '';
      serviceConfig = {
        ExecStart = "${nginx}/bin/nginx -c ${configFile} -p ${cfg.stateDir}";
      };
    };

    users.extraUsers = optionalAttrs (cfg.user == "nginx") (singleton
      { name = "nginx";
        group = "nginx";
        uid = config.ids.uids.nginx;
      });

    users.extraGroups = optionalAttrs (cfg.group == "nginx") (singleton
      { name = "nginx";
        gid = config.ids.gids.nginx;
      });
  };
}
