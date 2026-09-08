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
  meta.maintainers = with lib.maintainers; [ blaobla ];

  options.services.hysteria = {
    enable = lib.mkEnableOption "Hysteria proxy service";

    package = lib.mkPackageOption pkgs "hysteria" { };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = "./configs/hysteria.yaml";
      description = "Path to your Hysteria YAML configuration file.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 443;
      description = "Allow cliets to connect your hysteria server port";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Firewall rules for Hysteria.";
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
        StateDirectoryMode = "0700";

        ExecStart = [
          "${lib.getExe cfg.package} server -c ${cfg.configFile}"
        ];

        Restart = "on-failure";
        RestartSec = "5s";

        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        LimitNOFILE = 65536;
      };
    };

  };
}
