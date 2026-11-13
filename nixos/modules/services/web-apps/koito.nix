{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.koito;

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
in
{
  options.services.koito = {
    enable = mkEnableOption "koito";

    package = mkPackageOption pkgs "koito" { };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open the appropriate ports in the firewall for Koito.";
    };

    environment = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf types.str;
        options = {
          KOITO_BIND_ADDR = mkOption {
            type = types.str;
            default = "127.0.0.1";
            example = "0.0.0.0";
            description = "The IP address to bind the Koito server to.";
          };
          KOITO_LISTEN_PORT = mkOption {
            type = types.port;
            default = 4110;
            description = "TCP port for the Koito server.";
          };
          KOITO_CONFIG_DIR = mkOption {
            type = types.path;
            default = "/var/lib/koito";
            description = "Directory for Koito import folders and image caches.";
          };
        };
      };
      default = { };
      example = {
        KOITO_DEFAULT_THEME = "black";
        KOITO_LOGIN_GATE = "true";
      };
      description = ''
        Environment variables to pass to the Koito service.
        See <https://koito.io/reference/configuration/> for available options.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      example = "/run/secrets/koito";
      default = null;
      description = ''
        Path of a file with extra environment variables to be loaded from disk.
        This file is not added to the nix store, so it can be used to pass secrets to Koito.
        See <https://koito.io/reference/configuration/> for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.koito = {
      description = "Koito - modern scrobbler";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Environment = lib.mapAttrsToList (k: v: "${k}=${if builtins.isInt v then toString v else v}") (
          lib.filterAttrs (_: v: v != null) cfg.environment
        );
        DynamicUser = true;
        ExecStart = getExe cfg.package;
        StateDirectory = "koito";
        EnvironmentFile = cfg.environmentFile;

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectControlGroups = true;
        ProtectKernelTunables = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        UMask = "0077";

        CapabilityBoundingSet = [ "" ];
        NoNewPrivileges = true;

        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];

        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];

        PrivateUsers = true;

        LockPersonality = true;
        ProtectHostname = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        DeviceAllow = [ "" ];
      };
    };
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.environment.KOITO_LISTEN_PORT ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ iv-nn ];
  };
}
