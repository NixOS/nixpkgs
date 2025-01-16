{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.soarca;
in
{
  options.services.soarca = {
    enable = lib.mkEnableOption "SOARCA";
    package = lib.mkPackageOption pkgs "soarca" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (
            nullOr (oneOf [
              bool
              int
              str
            ])
          );
        options = { };
      };
      default = { };
      example = {
        PORT = 9000;
        GIN_MODE = "release";
        DATABASE = false;
      };
      description = ''
        See [the wiki](https://cossas.github.io/SOARCA/docs/installation-configuration/) for available settings.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "soarca";
      description = "User under which SOARCA will run.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "soarca";
      description = "Group under which SOARCA will run.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];

    systemd.services.soarca = {
      description = "SOARCA Service";
      wantedBy = [ "multi-user.target" ];
      restartIfChanged = true;

      environment = lib.mapAttrs (
        _: v: if lib.isBool v then lib.boolToString v else toString v
      ) cfg.settings;

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "on-failure";
        RestartSec = "5";

        # hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        ProtectSystem = "strict";
        ProtectHome = "true";
        ProtectProc = "invisible";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@clock @swap @reboot @raw-io @privileged @obsolete @mount @module @debug @cpu-emulation"
        ];
        CapabilityBoundingSet = [ "" ];
        RestrictNamespaces = true;
        ProcSubset = "pid";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
      };
    };

    users.users = lib.optionalAttrs (cfg.user == "soarca") {
      soarca = {
        group = cfg.group;
        isNormalUser = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "soarca") {
      soarca = { };
    };
  };

  meta.maintainers = with lib.maintainers; [ _13621 ];
}
