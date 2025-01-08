{ config, pkgs, lib, ... }:

let

  cfg = config.services.sniproxy;

  configFile = pkgs.writeText "sniproxy.conf" ''
    user ${cfg.user}
    pidfile /run/sniproxy.pid
    ${cfg.config}
  '';

in
{
  imports = [ (lib.mkRemovedOptionModule [ "services" "sniproxy" "logDir" ] "Now done by LogsDirectory=. Set to a custom path if you log to a different folder in your config.") ];

  options = {
    services.sniproxy = {
      enable = lib.mkEnableOption "sniproxy server";

      user = lib.mkOption {
        type = lib.types.str;
        default = "sniproxy";
        description = "User account under which sniproxy runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "sniproxy";
        description = "Group under which sniproxy runs.";
      };

      config = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "sniproxy.conf configuration excluding the daemon username and pid file.";
        example = ''
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
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.sniproxy = {
      description = "sniproxy server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.sniproxy}/bin/sniproxy -c ${configFile}";
        LogsDirectory = "sniproxy";
        LogsDirectoryMode = "0640";
        Restart = "always";
      };
    };

    users.users = lib.mkIf (cfg.user == "sniproxy") {
      sniproxy = {
        group = cfg.group;
        uid = config.ids.uids.sniproxy;
      };
    };

    users.groups = lib.mkIf (cfg.group == "sniproxy") {
      sniproxy = {
        gid = config.ids.gids.sniproxy;
      };
    };

  };
}
