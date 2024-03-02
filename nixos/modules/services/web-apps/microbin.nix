{ config, lib, pkgs, ... }:

let
  cfg = config.services.microbin;
in
{
  options.services.microbin = {
    enable = lib.mkEnableOption (lib.mdDoc "MicroBin is a super tiny, feature rich, configurable paste bin web application");

    package = lib.mkPackageOption pkgs "microbin" { };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = with lib.types; attrsOf (oneOf [ bool int str ]); };
      default = { };
      example = {
        MICROBIN_PORT = 8080;
        MICROBIN_HIDE_LOGO = false;
      };
      description = lib.mdDoc ''
        Additional configuration for MicroBin, see
        <https://microbin.eu/docs/installation-and-configuration/configuration/>
        for supported values.

        For secrets use passwordFile option instead.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/microbin";
      description = lib.mdDoc "Default data folder for MicroBin.";
    };

    passwordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/microbin.env";
      description = lib.mdDoc ''
        Path to file containing environment variables.
        Useful for passing down secrets.
        Variables that can be considered secrets are:
         - MICROBIN_BASIC_AUTH_USERNAME
         - MICROBIN_BASIC_AUTH_PASSWORD
         - MICROBIN_ADMIN_USERNAME
         - MICROBIN_ADMIN_PASSWORD
         - MICROBIN_UPLOADER_PASSWORD
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.microbin.settings = with lib; {
      MICROBIN_BIND = mkDefault "0.0.0.0";
      MICROBIN_DISABLE_TELEMETRY = mkDefault true;
      MICROBIN_LIST_SERVER = mkDefault false;
      MICROBIN_PORT = mkDefault "8080";
    };

    systemd.services.microbin = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = lib.mapAttrs (_: v: if lib.isBool v then lib.boolToString v else toString v) cfg.settings;
      serviceConfig = {
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        DevicePolicy = "closed";
        DynamicUser = true;
        EnvironmentFile = lib.optional (cfg.passwordFile != null) cfg.passwordFile;
        ExecStart = "${cfg.package}/bin/microbin";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ReadWritePaths = cfg.dataDir;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        StateDirectory = "microbin";
        SystemCallArchitectures = [ "native" ];
        SystemCallFilter = [ "@system-service" ];
        WorkingDirectory = cfg.dataDir;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ surfaceflinger ];
}
