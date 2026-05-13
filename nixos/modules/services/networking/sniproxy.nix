{
  config,
  pkgs,
  lib,
  ...
}:

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
  imports = [
    (mkRemovedOptionModule [ "services" "sniproxy" "logDir" ]
      "Now done by LogsDirectory=. Set to a custom path if you log to a different folder in your config."
    )
  ];

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

  config = mkIf cfg.enable {
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

    users.users = mkIf (cfg.user == "sniproxy") {
      sniproxy = {
        group = cfg.group;
        uid = config.ids.uids.sniproxy;
      };
    };

    users.groups = mkIf (cfg.group == "sniproxy") {
      sniproxy = {
        gid = config.ids.gids.sniproxy;
      };
    };

  };
}
