{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.recyclarr;
in
{
  options.services.recyclarr = {
    enable = mkEnableOption "recyclarr service";

    package = mkOption {
      type = types.package;
      default = pkgs.recyclarr;
      defaultText = literalExpression "pkgs.recyclarr";
      description = "The recyclarr package to use.";
    };

    command = mkOption {
      type = types.str;
      default = "sync";
      description = "The recyclarr command to run (e.g., sync).";
    };

    configFile = mkOption {
      type = types.either types.path types.str;
      description = lib.mdDoc ''
        Path to a compatible recyclarr configuration file.
        The file should be a valid YAML configuration following the recyclarr specification.
        For detailed configuration options and examples, see the
        [official configuration reference](https://recyclarr.dev/wiki/yaml/config-reference/).
      '';
    };

    workingDir = mkOption {
      type = types.path;
      default = "/var/lib/recyclarr";
      description = "Working directory for recyclarr.";
    };

    schedule = mkOption {
      type = types.str;
      default = "*-*-* 04:00:00"; # Every day at 4 AM
      description = "When to run recyclarr in systemd calendar format.";
    };

    user = mkOption {
      type = types.str;
      default = "recyclarr";
      description = "User account under which recyclarr runs.";
    };

    group = mkOption {
      type = types.str;
      default = "recyclarr";
      description = "Group under which recyclarr runs.";
    };
  };

  config = mkIf cfg.enable {

    users.users = mkIf (cfg.user == "recyclarr") {
      recyclarr = {
        isSystemUser = true;
        description = "recyclarr user";
        home = cfg.workingDir;
        group = cfg.group;
      };
    };

    users.groups = mkIf (cfg.group == "recyclarr") {
      ${cfg.group} = { };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.workingDir} 0750 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.recyclarr = {
      description = "Recyclarr Service";
      after = [ "network.target" ];
      path = [ cfg.package ];

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.workingDir;
        ExecStart = "${lib.getExe cfg.package} ${cfg.command} --app-data ${cfg.workingDir} --config ${cfg.configFile}";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;

        PrivateNetwork = false;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];

        NoNewPrivileges = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;

        ReadOnlyPaths = [ cfg.configFile ];
        ReadWritePaths = [ cfg.workingDir ];

        CapabilityBoundingSet = "";

        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
      };
    };

    systemd.timers.recyclarr = {
      description = "Recyclarr Timer";
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = cfg.schedule;
        Persistent = true;
        RandomizedDelaySec = "5m";
        Unit = "recyclarr.service";
      };
    };
  };
}
