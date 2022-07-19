{ config, lib, pkgs, ... }:

with lib;

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

      enable = mkEnableOption "heartbeat";

      package = mkOption {
        type = types.package;
        default = pkgs.heartbeat;
        defaultText = literalExpression "pkgs.heartbeat";
        example = literalExpression "pkgs.heartbeat7";
        description = ''
          The heartbeat package to use.
        '';
      };

      name = mkOption {
        type = types.str;
        default = "heartbeat";
        description = "Name of the beat";
      };

      tags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Tags to place on the shipped log messages";
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/heartbeat";
        description = "The state directory. heartbeat's own logs and other data are stored here.";
      };

      extraConfig = mkOption {
        type = types.lines;
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

  config = mkIf cfg.enable {

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
