{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.services.docling-serve;
in
{
  options = {
    services.docling-serve = {
      enable = lib.mkEnableOption "Docling Serve server";
      package = lib.mkPackageOption pkgs "docling-serve" { };

      stateDir = lib.mkOption {
        type = types.path;
        default = "/var/lib/docling-serve";
        example = "/home/foo";
        description = "State directory of Docling Serve.";
      };

      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = ''
          The host address which the Docling Serve server HTTP interface listens to.
        '';
      };

      port = lib.mkOption {
        type = types.port;
        default = 5001;
        example = 11111;
        description = ''
          Which port the Docling Serve server listens to.
        '';
      };

      environment = lib.mkOption {
        type = types.attrsOf types.str;
        default = {
          DOCLING_SERVE_ENABLE_UI = "False";
        };
        example = ''
          {
            DOCLING_SERVE_ENABLE_UI = "True";
          }
        '';
        description = ''
          Extra environment variables for Docling Serve.
          For more details see <https://github.com/docling-project/docling-serve/blob/main/docs/configuration.md>
        '';
      };

      environmentFile = lib.mkOption {
        description = ''
          Environment file to be passed to the systemd service.
          Useful for passing secrets to the service to prevent them from being
          world-readable in the Nix store.
        '';
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/secrets/doclingServeSecrets";
      };

      openFirewall = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for Docling Serve.
          This adds `services.Docling Serve.port` to `networking.firewall.allowedTCPPorts`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.docling-serve = {
      description = "Running Docling as an API service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        HF_HOME = ".";
        EASYOCR_MODULE_PATH = ".";
        MPLCONFIGDIR = ".";
      }
      // cfg.environment;

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} run --host \"${cfg.host}\" --port ${toString cfg.port}";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "docling-serve";
        RuntimeDirectory = "docling-serve";
        RuntimeDirectoryMode = "0755";
        PrivateTmp = true;
        DynamicUser = true;
        DevicePolicy = "closed";
        LockPersonality = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        ProtectClock = true;
        ProtectProc = "invisible";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };

  meta.maintainers = [ ];
}
