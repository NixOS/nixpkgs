{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.hysteria;
in
{
  meta = with lib.maintainers; {
    maintainers = [ blaobla ];
  };

  options = {
    services.hysteria = with lib; {
      enable = mkEnableOption "Hysteria proxy service";

      package = mkPackageOption pkgs "hysteria" { };

      configFile = mkOption {
        type = types.path;
        default = "./configs/hysteria.yaml";
        description = "Path to your Hysteria YAML configuration file.";
      };

      port = mkOption {
        type = types.port;
        default = 443;
        description = "Allow cliets to connect your hysteria server port";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = "Firewall rules for Hysteria.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 443 ];
      allowedUDPPorts = [ cfg.port ];
    };

    users.users.hysteria = {
      isSystemUser = true;
      group = "hysteria";
      home = "/var/lib/hysteria";
      createHome = true;
    };
    users.groups.hysteria = { };

    systemd.services.hysteria = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        User = "hysteria";
        Group = "hysteria";
        WorkingDirectory = "/var/lib/hysteria";
        StateDirectory = "hysteria";
        StateDirectoryMode = "0750";

        ExecStart = [
          ""
          "${lib.getExe cfg.package} server -c ${cfg.configFile}"
        ];

        Restart = "on-failure";
        RestartSec = "5s";

        # 安全加固
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        LimitNOFILE = 65536;
      };
    };

    boot.kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";

      "net.ipv4.tcp_rmem" = "4096 131072 1048576";
      "net.ipv4.tcp_wmem" = "4096 65536 1048576";
      "net.ipv4.tcp_mem" = "262144 524288 786432";

      "net.ipv4.tcp_fin_timeout" = "30";
      "net.ipv4.tcp_tw_reuse" = "1";
      "net.ipv4.tcp_fastopen" = "1";
      "net.ipv4.tcp_slow_start_after_idle" = "0";

      "net.core.somaxconn" = "1024";
      "net.core.netdev_max_backlog" = "1024";

      "net.mptcp.enabled" = "0"; # 单核单内存，不开多路径
    };

  };
}
