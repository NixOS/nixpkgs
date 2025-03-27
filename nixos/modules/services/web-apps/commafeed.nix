{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.commafeed;
in
{
  options.services.commafeed = {
    enable = lib.mkEnableOption "CommaFeed";

    package = lib.mkPackageOption pkgs "commafeed" { };

    user = lib.mkOption {
      type = lib.types.str;
      description = "User under which CommaFeed runs.";
      default = "commafeed";
    };

    group = lib.mkOption {
      type = lib.types.str;
      description = "Group under which CommaFeed runs.";
      default = "commafeed";
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      description = "Directory holding all state for CommaFeed to run.";
      default = "/var/lib/commafeed";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.bool
          lib.types.int
          lib.types.str
        ]
      );
      description = ''
        Extra environment variables passed to CommaFeed, refer to
        <https://github.com/Athou/commafeed/blob/master/commafeed-server/config.yml.example>
        for supported values. The default user is `admin` and the default password is `admin`.
        Correct configuration for H2 database is already provided.
      '';
      default = { };
      example = {
        CF_SERVER_APPLICATIONCONNECTORS_0_TYPE = "http";
        CF_SERVER_APPLICATIONCONNECTORS_0_PORT = 9090;
      };
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)`.
      '';
      default = null;
      example = "/var/lib/commafeed/commafeed.env";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.commafeed = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = lib.mapAttrs (
        _: v: if lib.isBool v then lib.boolToString v else toString v
      ) cfg.environment;
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} server ${cfg.package}/share/config.yml";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = baseNameOf cfg.stateDir;
        WorkingDirectory = cfg.stateDir;
        # Hardening
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        DynamicUser = true;
        LockPersonality = true;
        NoNewPrivileges = true;
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
        ProtectSystem = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      } // lib.optionalAttrs (cfg.environmentFile != null) { EnvironmentFile = cfg.environmentFile; };
    };
  };

  meta.maintainers = [ lib.maintainers.raroh73 ];
}
