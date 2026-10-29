{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  cfg = config.services.nvme-rs;
  opt = options.services.nvme-rs;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.services.nvme-rs = {
    enable = lib.mkEnableOption "nvme-rs, a monitoring service";

    package = lib.mkPackageOption pkgs "nvme-rs" { };

    settings = lib.mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          check_interval_secs = lib.mkOption {
            type = types.int;
            default = 3600;
            description = "Check interval in seconds";
            example = 86400;
          };

          thresholds = lib.mkOption {
            type = types.submodule {
              freeformType = settingsFormat.type;
              options = {
                temp_warning = lib.mkOption {
                  type = types.int;
                  default = 55;
                  description = "Temperature warning threshold (°C)";
                };

                temp_critical = lib.mkOption {
                  type = types.int;
                  default = 65;
                  description = "Temperature critical threshold (°C)";
                };

                wear_warning = lib.mkOption {
                  type = types.int;
                  default = 20;
                  description = "Wear warning threshold (%)";
                };

                wear_critical = lib.mkOption {
                  type = types.int;
                  default = 50;
                  description = "Wear critical threshold (%)";
                };

                spare_warning = lib.mkOption {
                  type = types.int;
                  default = 50;
                  description = "Available spare warning threshold (%)";
                };

                error_threshold = lib.mkOption {
                  type = types.int;
                  default = 100;
                  description = "Error count warning threshold";
                };
              };
            };
            default = { };
            description = "Threshold configuration for NVMe monitoring";
          };

          email = lib.mkOption {
            type = types.nullOr (
              types.submodule {
                freeformType = settingsFormat.type;
                options = {
                  smtp_server = lib.mkOption {
                    type = types.str;
                    default = "smtp.gmail.com";
                    description = "SMTP server address";
                    example = "mail.example.com";
                  };

                  smtp_port = lib.mkOption {
                    type = types.port;
                    default = 587;
                    description = "SMTP server port";
                  };

                  smtp_username = lib.mkOption {
                    type = types.str;
                    description = "SMTP username";
                    example = "your-email@gmail.com";
                  };

                  smtp_password_file = lib.mkOption {
                    type = types.path;
                    description = "File containing SMTP password";
                    example = "/run/secrets/smtp-password";
                  };

                  from = lib.mkOption {
                    type = types.str;
                    description = "Sender email address";
                    example = "nvme-monitor@example.com";
                  };

                  to = lib.mkOption {
                    type = types.str;
                    description = "Recipient email address";
                    example = "admin@example.com";
                  };

                  use_tls = lib.mkOption {
                    type = types.bool;
                    default = true;
                    description = "Use TLS for SMTP connection";
                  };
                };
              }
            );
            default = null;
            description = "Email notification configuration";
          };
        };
      };
      default = { };
      description = ''
        Configuration for nvme-rs in TOML format.
        See the config.toml example for all available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.nvme-rs.settings = opt.settings.default;

    systemd.services.nvme-rs = {
      description = "NVMe health monitoring service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig =
        let
          settingsWithoutNull =
            if cfg.settings.email == null then lib.removeAttrs cfg.settings [ "email" ] else cfg.settings;
          configFile = settingsFormat.generate "nvme-rs.toml" settingsWithoutNull;
        in
        {
          ExecStart = lib.escapeShellArgs [
            "${lib.getExe cfg.package}"
            "daemon"
            "--config"
            "${configFile}"
          ];

          DynamicUser = true;
          SupplementaryGroups = [ "disk" ];
          CapabilityBoundingSet = [ "CAP_SYS_ADMIN" ];
          AmbientCapabilities = [ "CAP_SYS_ADMIN" ];
          LimitCORE = 0;
          LimitNOFILE = 65535;
          LockPersonality = true;
          MemorySwapMax = 0;
          MemoryZSwapMax = 0;
          PrivateTmp = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          Restart = "on-failure";
          RestartSec = "10s";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "@resources"
            "~@privileged"
          ];
          NoNewPrivileges = true;
          UMask = "0077";
        };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
