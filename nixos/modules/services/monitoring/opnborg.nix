{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.opnborg;
in
{
  options.services.opnborg = {
    enable = mkEnableOption "opnborg";

    extraOptions = mkOption {
      type = with types; attrsOf str;
      default = { };
      example = ''
        # minimal config
        "OPN_TARGETS" = "opn01.lan";
        "OPN_APIKEY" = "+RIb6YWNdcDWMMM7W5ZYDkUvP4qx6e1r7e/Lg/Uh3aBH+veuWfKc7UvEELH/lajWtNxkOaOPjWR8uMcD";
        "OPN_APISECRET" = "8VbjM3HKKqQW2ozOe5PTicMXOBVi9jZTSPCGfGrHp8rW6m+TeTxHyZyAI1GjERbuzjmz6jK/usMCWR/p";
        # full example
        "OPN_APIKEY" = "+RIb6YWNdcDWMMM7W5ZYDkUvP4qx6e1r7e/Lg/Uh3aBH+veuWfKc7UvEELH/lajWtNxkOaOPjWR8uMcD";
        "OPN_APISECRET" = "8VbjM3HKKqQW2ozOe5PTicMXOBVi9jZTSPCGfGrHp8rW6m+TeTxHyZyAI1GjERbuzjmz6jK/usMCWR/p";
        "OPN_TLSKEYPIN" = "8VbjM3HKKqQW2ozOe5PTicMXOBVi9jZTSPCGfGrHp8rW6m+TeTxHyZyAI1GjERbuzjmz6jK/usMCWR/p";
        "OPN_MASTER" = "opn01.lan:8443";
        "OPN_TARGETS_HOTSTANDBY" = "opn00.lan:8443";
        "OPN_TARGETS_PRODUCTION" = "opn01.lan:8443,opn02.lan:8443";
        "OPN_TARGETS_IMGURL_HOTSTANDBY" = "https://icon-library.com/images/freebsd-icon/freebsd-icon-16.jpg";
        "OPN_TARGETS_IMGURL_PRODUCTION" = "https://icon-library.com/images/freebsd-icon/freebsd-icon-16.jpg";
        "OPN_SLEEP" = "3600"; # seconds
        "OPN_DEBUG" = "true";
        "OPN_SYNC_PKG" = "true";
        "OPN_HTTPD_ENABLE" = "true";
        "OPN_HTTPD_SERVER" = "127.0.0.1:6464"; # port must be above 1024
        "OPN_HTTPD_COLOR_FG" = "white";
        "OPN_HTTPD_COLOR_BG" = "grey";
        "OPN_RSYSLOG_ENABLE" = "true";
        "OPN_RSYSLOG_SERVER" = "192.168.122.1:5140";
        "OPN_GRAFANA_WEBUI" = "http://localhost:9090";
        "OPN_GRAFANA_DASHBOARD_FREEBSD" = "Kczn-jPZz/node-exporter-freebsd";
        "OPN_GRAFANA_DASHBOARD_HAPROXY" = "rEqu1u5ue/haproxy-2-full";
        "OPN_WAZUH_WEBUI" = "http://localhost:9292";
        "OPN_PROMETHEUS_WEBUI" = "http://localhost:9191";
      '';
      description = ''
        Additional setup enviroment variables
        Details and more examples: https://github.com/paepckehh/opnborg
        - Keep opnborg services tcp port numbers > 1024.
        - Storage Path: /var/lib/opnborg (do not set OPN_PATH)
      '';
    };
  };

  config = mkIf config.services.opnborg.enable {
    users = {
      users = {
        opnborg = {
          createHome = true;
          description = "opnborg service account";
          uid = 6464;
          isSystemUser = true;
          group = "opnborg";
          home = "/var/lib/opnborg";
        };
      };
      groups."opnborg" = {
        name = "opnborg";
        members = [ "opnborg" ];
        gid = 6464;
      };
    };

    environment.systemPackages = [ pkgs.opnborg ];

    systemd.services.opnborg = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "OPNBorg Service";
      environment = cfg.extraOptions;
      serviceConfig = {
        ExecStart = "${pkgs.opnborg}/bin/opnborg";
        KillMode = "process";
        Restart = "always";
        PreStart = "cd /var/lib/opnborg";
        User = "opnborg";
        StateDirectory = "opnborg";
        StateDirectoryMode = "0750";
        WorkingDirectory = "/var/lib/opnborg";
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
      };
    };
  };

  meta.maintainers = with maintainers; [ paepcke ];
}
