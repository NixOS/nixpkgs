{ config, lib, pkgs, ... }:
let
  cfg = config.services.heartbeat;

  heartbeatYml = pkgs.writeText "heartbeat.yml" ''
    name: ${cfg.name}
    tags: ${builtins.toJSON cfg.tags}

    ${cfg.extraConfig}
  '';

in
{
  options = {

    services.heartbeat = {

      enable = lib.mkEnableOption "heartbeat, uptime monitoring";

      package = lib.mkPackageOption pkgs "heartbeat" {
        example = "heartbeat7";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "heartbeat";
        description = "Name of the beat";
      };

      tags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Tags to place on the shipped log messages";
      };

      stateDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/heartbeat";
        description = "The state directory. heartbeat's own logs and other data are stored here.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = ''
          heartbeat.monitors:
          - type: http
            urls: ["http://localhost:9200"]
            schedule: '@every 10s'
        '';
        description = "Any other configuration options you want to add";
      };

    };
  };

  config = lib.mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' - nobody nogroup - -"
    ];

    systemd.services.heartbeat = with pkgs; {
      description = "heartbeat log shipper";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p "${cfg.stateDir}"/{data,logs}
      '';
      serviceConfig = {
        User = "nobody";
        AmbientCapabilities = "cap_net_raw";
        ExecStart = "${cfg.package}/bin/heartbeat -c \"${heartbeatYml}\" -path.data \"${cfg.stateDir}/data\" -path.logs \"${cfg.stateDir}/logs\"";
      };
    };
  };
}
