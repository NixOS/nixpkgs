{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.sniproxy;

  configFile = pkgs.writeText "sniproxy.conf" ''
    user ${cfg.user}
    pidfile /run/sniproxy.pid
    ${cfg.config}
  '';

in
{
  options = {
    services.sniproxy = {
      enable = mkEnableOption "sniproxy server";

      user = mkOption {
        type = types.str;
        default = "sniproxy";
        description = "User account under which sniproxy runs.";
      };

      group = mkOption {
        type = types.str;
        default = "sniproxy";
        description = "Group under which sniproxy runs.";
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = "sniproxy.conf configuration excluding the daemon username and pid file.";
        example = literalExample ''
          error_log {
            filename /var/log/sniproxy/error.log
          }
          access_log {
            filename /var/log/sniproxy/access.log
          }
          listen 443 {
            proto tls
          }
          table {
            example.com 192.0.2.10
            example.net 192.0.2.20
        }
        '';
      };

      logDir = mkOption {
        type = types.str;
        default = "/var/log/sniproxy/";
        description = "Location of the log directory for sniproxy.";
      };

    };

  };

  config = mkIf cfg.enable {
    systemd.services.sniproxy = {
      description = "sniproxy server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        test -d ${cfg.logDir} || {
          echo "Creating initial log directory for sniproxy in ${cfg.logDir}"
          mkdir -p ${cfg.logDir}
          chmod 640 ${cfg.logDir}
          }
        chown -R ${cfg.user}:${cfg.group} ${cfg.logDir}
      '';

      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.sniproxy}/bin/sniproxy -c ${configFile}";
        Restart = "always";
      };
    };

    users.extraUsers = mkIf (cfg.user == "sniproxy") {
      sniproxy = {
        group = cfg.group;
        uid = config.ids.uids.sniproxy;
      };
    };

    users.extraGroups = mkIf (cfg.group == "sniproxy") {
      sniproxy = {
        gid = config.ids.gids.sniproxy;
      };
    };

  };
}
