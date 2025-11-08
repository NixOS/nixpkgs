{
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.memos;
  opt = options.services.memos;
  envFileFormat = pkgs.formats.keyValue { };
in
{
  options.services.memos = {
    enable = lib.mkEnableOption "Memos note-taking";
    package = lib.mkPackageOption pkgs "Memos" {
      default = "memos";
    };

    openFirewall = lib.mkEnableOption "opening the ports in the firewall";

    user = lib.mkOption {
      type = lib.types.str;
      description = ''
        The user to run Memos as.

        ::: {.note}
        If changing the default value, **you** are responsible of creating the corresponding user with [{option}`users.users`](#opt-users.users).
        :::
      '';
      default = "memos";
    };

    group = lib.mkOption {
      type = lib.types.str;
      description = ''
        The group to run Memos as.

        ::: {.note}
        If changing the default value, **you** are responsible of creating the corresponding group with [{option}`users.groups`](#opt-users.groups).
        :::
      '';
      default = "memos";
    };

    dataDir = lib.mkOption {
      default = "/var/lib/memos/";
      type = lib.types.path;
      description = ''
        Specifies the directory where Memos will store its data.

        ::: {.note}
        It will be automatically created with the permissions of [{option}`services.memos.user`](#opt-services.memos.user) and [{option}`services.memos.group`](#opt-services.memos.group).
        :::
      '';
    };

    settings = lib.mkOption {
      type = envFileFormat.type;
      description = ''
        The environment variables to configure Memos.

        ::: {.note}
        At time of writing, there is no clear documentation about possible values.
        It's possible to convert CLI flags into these variables.
        Example : CLI flag "--unix-sock" converts to {env}`MEMOS_UNIX_SOCK`.
        :::
      '';
      default = {
        MEMOS_MODE = "prod";
        MEMOS_ADDR = "127.0.0.1";
        MEMOS_PORT = "5230";
        MEMOS_DATA = cfg.dataDir;
        MEMOS_DRIVER = "sqlite";
        MEMOS_INSTANCE_URL = "http://localhost:5230";
      };
      defaultText = lib.literalExpression ''
        {
          MEMOS_MODE = "prod";
          MEMOS_ADDR = "127.0.0.1";
          MEMOS_PORT = "5230";
          MEMOS_DATA = config.${opt.dataDir};
          MEMOS_DRIVER = "sqlite";
          MEMOS_INSTANCE_URL = "http://localhost:5230";
        }
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        The environment file to use when starting Memos.

        ::: {.note}
        By default, generated from [](opt-${opt.settings}).
        :::
      '';
      example = "/var/lib/memos/memos.env";
      default = envFileFormat.generate "memos.env" cfg.settings;
      defaultText = lib.literalMD ''
        generated from {option}`${opt.settings}`
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf (cfg.user == "memos") {
      ${cfg.user} = {
        description = lib.mkDefault "Memos service user";
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = lib.mkIf (cfg.group == "memos") {
      ${cfg.group} = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
    ];

    systemd.tmpfiles.settings."10-memos" = {
      "${cfg.dataDir}" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };
    };

    systemd.services.memos = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      wants = [ "network.target" ];
      description = "Memos, a privacy-first, lightweight note-taking solution";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        RestartSec = 60;
        LimitNOFILE = 65536;
        NoNewPrivileges = true;
        LockPersonality = true;
        RemoveIPC = true;
        ReadWritePaths = [
          cfg.dataDir
        ];
        ProtectSystem = "strict";
        PrivateUsers = true;
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        UMask = "0077";
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        SystemCallFilter = [
          " " # This is needed to clear the SystemCallFilter existing definitions
          "~@reboot"
          "~@swap"
          "~@obsolete"
          "~@mount"
          "~@module"
          "~@debug"
          "~@cpu-emulation"
          "~@clock"
          "~@raw-io"
          "~@privileged"
          "~@resources"
        ];
        CapabilityBoundingSet = [
          " " # Reset all capabilities to an empty set
        ];
        RestrictAddressFamilies = [
          " " # This is needed to clear the RestrictAddressFamilies existing definitions
          "none" # Remove all addresses families
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        DevicePolicy = "closed";
        ProtectKernelLogs = true;
        SystemCallArchitectures = "native";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        EnvironmentFile = cfg.environmentFile;
        ExecStart = lib.getExe cfg.package;
      };
    };
  };

  meta.maintainers = [ lib.maintainers.m0ustach3 ];
}
