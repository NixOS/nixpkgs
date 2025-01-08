{ config, pkgs, lib, ... }:

let
  cfg = config.services.teleport;
  settingsYaml = pkgs.formats.yaml { };
in
{
  options = {
    services.teleport = with lib.types; {
      enable = lib.mkEnableOption "the Teleport service";

      package = lib.mkPackageOption pkgs "teleport" {
        example = "teleport_11";
      };

      settings = lib.mkOption {
        type = settingsYaml.type;
        default = { };
        example = lib.literalExpression ''
          {
            teleport = {
              nodename = "client";
              advertise_ip = "192.168.1.2";
              auth_token = "60bdc117-8ff4-478d-95e4-9914597847eb";
              auth_servers = [ "192.168.1.1:3025" ];
              log.severity = "DEBUG";
            };
            ssh_service = {
              enabled = true;
              labels = {
                role = "client";
              };
            };
            proxy_service.enabled = false;
            auth_service.enabled = false;
          }
        '';
        description = ''
          Contents of the `teleport.yaml` config file.
          The `--config` arguments will only be passed if this set is not empty.

          See <https://goteleport.com/docs/setup/reference/config/>.
        '';
      };

      insecure.enable = lib.mkEnableOption ''
        starting teleport in insecure mode.

        This is dangerous!
        Sensitive information will be logged to console and certificates will not be verified.
        Proceed with caution!

        Teleport starts with disabled certificate validation on Proxy Service, validation still occurs on Auth Service
      '';

      diag = {
        enable = lib.mkEnableOption ''
          endpoints for monitoring purposes.

          See <https://goteleport.com/docs/setup/admin/troubleshooting/#troubleshooting/>
        '';

        addr = lib.mkOption {
          type = str;
          default = "127.0.0.1";
          description = "Metrics and diagnostics address.";
        };

        port = lib.mkOption {
          type = port;
          default = 3000;
          description = "Metrics and diagnostics port.";
        };
      };
    };
  };

  config = lib.mkIf config.services.teleport.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.teleport = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = with pkgs; [ getent shadow sudo ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/teleport start \
            ${lib.optionalString cfg.insecure.enable "--insecure"} \
            ${lib.optionalString cfg.diag.enable "--diag-addr=${cfg.diag.addr}:${toString cfg.diag.port}"} \
            ${lib.optionalString (cfg.settings != { }) "--config=${settingsYaml.generate "teleport.yaml" cfg.settings}"}
        '';
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        LimitNOFILE = 65536;
        Restart = "always";
        RestartSec = "5s";
        RuntimeDirectory = "teleport";
        Type = "simple";
      };
    };
  };
}

