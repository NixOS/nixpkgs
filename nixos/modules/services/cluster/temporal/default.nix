{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.temporal;

  settingsFormat = pkgs.formats.yaml { };

  usingDefaultDataDir = cfg.dataDir == "/var/lib/temporal";
  usingDefaultUserAndGroup = cfg.user == "temporal" && cfg.group == "temporal";
in
{
  meta.maintainers = [ lib.maintainers.jpds ];

  options.services.temporal = {
    enable = lib.mkEnableOption "Temporal";

    package = lib.mkPackageOption pkgs "Temporal" {
      default = [ "temporal" ];
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };

      description = ''
        Temporal configuration.

        See <https://docs.temporal.io/references/configuration> for more
        information about Temporal configuration options
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/temporal";
      apply = lib.converge (lib.removeSuffix "/");
      description = ''
        Data directory for Temporal. If you change this, you need to
        manually create the directory. You also need to create the
        `temporal` user and group, or change
        [](#opt-services.temporal.user) and
        [](#opt-services.temporal.group) to existing ones with
        access to the directory.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "temporal";
      description = ''
        The user Temporal runs as. Should be left at default unless
        you have very specific needs.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "temporal";
      description = ''
        The group temporal runs as. Should be left at default unless
        you have very specific needs.
      '';
    };

    restartIfChanged = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Automatically restart the service on config change.
        This can be set to false to defer restarts on a server or cluster.
        Please consider the security implications of inadvertently running an older version,
        and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
      '';
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."temporal/temporal-server.yaml".source =
      settingsFormat.generate "temporal-server.yaml" cfg.settings;

    systemd.services.temporal = {
      description = "Temporal server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      inherit (cfg) restartIfChanged;
      restartTriggers = [ config.environment.etc."temporal/temporal-server.yaml".source ];
      environment = {
        HOME = cfg.dataDir;
      };
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/temporal-server --root / --config /etc/temporal/ -e temporal-server start
        '';
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        DynamicUser = usingDefaultUserAndGroup && usingDefaultDataDir;
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = [
          cfg.dataDir
        ];
        RestrictAddressFamilies = [
          "AF_NETLINK"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          # 1. allow a reasonable set of syscalls
          "@system-service @resources"
          # 2. and deny unreasonable ones
          "~@privileged"
          # 3. then allow the required subset within denied groups
          "@chown"
        ];
      }
      // (lib.optionalAttrs usingDefaultDataDir {
        StateDirectory = "temporal";
        StateDirectoryMode = "0700";
      });
    };
  };
}
