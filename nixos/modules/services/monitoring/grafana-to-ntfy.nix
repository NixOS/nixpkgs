{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.grafana-to-ntfy;
in
{
  meta.maintainers = with lib.maintainers; [ kittyandrew ];

  options = {
    services.grafana-to-ntfy = {
      enable = lib.mkEnableOption "grafana-to-ntfy, a Grafana/Alertmanager to ntfy.sh bridge";

      package = lib.mkPackageOption pkgs "grafana-to-ntfy" { };

      settings = {
        ntfyUrl = lib.mkOption {
          type = lib.types.str;
          description = "The URL to the ntfy-sh topic.";
          example = "https://push.example.com/grafana";
        };

        ntfyBAuthUser = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = ''
            The ntfy-sh user to use for authenticating with the ntfy-sh instance.
            Setting this option is required when using a ntfy-sh instance with access control enabled.
          '';
          default = null;
          example = "grafana";
        };

        ntfyBAuthPass = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = ''
            The path to the password for the specified ntfy-sh user.
            Setting this option is required when using a ntfy-sh instance with access control enabled.
          '';
          default = null;
          example = "/run/secrets/grafana-to-ntfy-ntfy-pass";
        };

        bauthUser = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = ''
            The user for Basic Auth on incoming webhook requests from Grafana or Alertmanager.
            When set together with {option}`bauthPass`, incoming requests require Basic Auth.
            When both are null, the endpoint is open (unauthenticated).
          '';
          default = null;
          example = "admin";
        };

        bauthPass = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = ''
            Path to the password file for Basic Auth on incoming webhook requests.
            When set together with {option}`bauthUser`, incoming requests require Basic Auth.
            When both are null, the endpoint is open (unauthenticated).
          '';
          default = null;
          example = "/run/secrets/grafana-to-ntfy-bauth-pass";
        };

        markdown = lib.mkOption {
          type = lib.types.bool;
          description = "Enable Markdown formatting in ntfy notifications. Sets the X-Markdown header.";
          default = false;
        };

        port = lib.mkOption {
          type = lib.types.port;
          description = "Port to listen on.";
          default = 8080;
        };

        address = lib.mkOption {
          type = lib.types.str;
          description = "Address to listen on.";
          default = "127.0.0.1";
          example = "0.0.0.0";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.settings.bauthUser == null) == (cfg.settings.bauthPass == null);
        message = "services.grafana-to-ntfy: bauthUser and bauthPass must both be set or both be null";
      }
      {
        assertion = (cfg.settings.ntfyBAuthUser == null) == (cfg.settings.ntfyBAuthPass == null);
        message = "services.grafana-to-ntfy: ntfyBAuthUser and ntfyBAuthPass must both be set or both be null";
      }
    ];

    systemd.services.grafana-to-ntfy = {
      description = "Grafana/Alertmanager to ntfy.sh bridge";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      script =
        let
          optionalCred = name: envVar: ''
            export ${envVar}="$(${lib.getExe' config.systemd.package "systemd-creds"} cat ${name})"
          '';
        in
        ''
          ${lib.optionalString (cfg.settings.bauthPass != null) (optionalCred "BAUTH_PASS_FILE" "BAUTH_PASS")}
          ${lib.optionalString (cfg.settings.ntfyBAuthPass != null) (optionalCred "NTFY_BAUTH_PASS_FILE" "NTFY_BAUTH_PASS")}
          exec ${lib.getExe cfg.package}
        '';

      environment =
        {
          NTFY_URL = cfg.settings.ntfyUrl;
          ROCKET_PORT = toString cfg.settings.port;
          ROCKET_ADDRESS = cfg.settings.address;
        }
        // lib.optionalAttrs (cfg.settings.bauthUser != null) {
          BAUTH_USER = cfg.settings.bauthUser;
        }
        // lib.optionalAttrs (cfg.settings.ntfyBAuthUser != null) {
          NTFY_BAUTH_USER = cfg.settings.ntfyBAuthUser;
        }
        // lib.optionalAttrs cfg.settings.markdown {
          MARKDOWN = "true";
        };

      serviceConfig = {
        LoadCredential =
          lib.optional (cfg.settings.bauthPass != null) "BAUTH_PASS_FILE:${cfg.settings.bauthPass}"
          ++ lib.optional (cfg.settings.ntfyBAuthPass != null) "NTFY_BAUTH_PASS_FILE:${cfg.settings.ntfyBAuthPass}";

        DynamicUser = true;

        Restart = "always";
        RestartSec = 5;

        # Hardening
        AmbientCapabilities = [ "" ];
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
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
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };
  };
}
