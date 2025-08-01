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
  options = {
    services.grafana-to-ntfy = {
      enable = lib.mkEnableOption "Grafana-to-ntfy (ntfy.sh) alerts channel";

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
          type = lib.types.path;
          description = ''
            The path to the password for the specified ntfy-sh user.
            Setting this option is required when using a ntfy-sh instance with access control enabled.
          '';
          default = null;
        };

        bauthUser = lib.mkOption {
          type = lib.types.str;
          description = ''
            The user that you will authenticate with in the Grafana webhook settings.
            You can set this to whatever you like, as this is not the same as the ntfy-sh user.
          '';
          default = "admin";
        };

        bauthPass = lib.mkOption {
          type = lib.types.path;
          description = "The path to the password you will use in the Grafana webhook settings.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.grafana-to-ntfy = {
      wantedBy = [ "multi-user.target" ];

      script = ''
        export BAUTH_PASS=$(${lib.getExe' config.systemd.package "systemd-creds"} cat BAUTH_PASS_FILE)
        ${lib.optionalString (cfg.settings.ntfyBAuthPass != null) ''
          export NTFY_BAUTH_PASS=$(${lib.getExe' config.systemd.package "systemd-creds"} cat NTFY_BAUTH_PASS_FILE)
        ''}
        exec ${lib.getExe cfg.package}
      '';

      environment = {
        NTFY_URL = cfg.settings.ntfyUrl;
        BAUTH_USER = cfg.settings.bauthUser;
      }
      // lib.optionalAttrs (cfg.settings.ntfyBAuthUser != null) {
        NTFY_BAUTH_USER = cfg.settings.ntfyBAuthUser;
      };

      serviceConfig = {
        LoadCredential = [
          "BAUTH_PASS_FILE:${cfg.settings.bauthPass}"
        ]
        ++ lib.optional (
          cfg.settings.ntfyBAuthPass != null
        ) "NTFY_BAUTH_PASS_FILE:${cfg.settings.ntfyBAuthPass}";

        DynamicUser = true;
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = "";
        LockPersonality = true;
        PrivateDevices = true;
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
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };
}
