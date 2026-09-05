# Non-module dependencies (`importApply`)
{ formats, coreutils }:

{
  config,
  lib,
  options,
  name,
  ...
}:
let
  cfg = config.git-pages;
  settingsFormat = formats.toml { };
  configFile = "git-pages.toml";
  configOutPath = config.configData.${configFile}.path;

  hardeningOptions = {
    # systemd service hardening
    ProtectHome = true;
    MemoryDenyWriteExecute = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectSystem = "strict";
    ProtectControlGroups = true;
    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
    RestrictNamespaces = true;
    LockPersonality = true;
    ProtectKernelLogs = true;
    ProtectKernelTunables = true;
    ProtectHostname = true;
    ProtectKernelModules = true;
    PrivateUsers = true;
    ProtectClock = true;
    SystemCallArchitectures = "native";
    SystemCallErrorNumber = "EPERM";
    SystemCallFilter = "@system-service";
  };
in
{
  _class = "service";

  meta.maintainers = with lib.maintainers; [
    dtomvan
    phanirithvij
  ];

  options.git-pages = {
    package = lib.mkOption {
      description = "Package to use for git-pages";
      defaultText = "The git-pages package that provided this module.";
      type = lib.types.package;
    };

    secretFile = lib.mkOption {
      description = ''
        File that contains secrets for the git-pages config.
        If values in this file are set, any options specified take priority over the options set in
        {option}`git-pages.settings`.

        ::: {.note}
        See the [git-pages documentation](https://git-pages.org/running-a-server/#configuration) on
        secrets and environment variables.
        :::
      '';
      default = null;
      type = lib.types.nullOr lib.types.str;
    };

    cleanupInterval = lib.mkOption {
      description = ''
        Systemd calendar event (e.g. `weekly`, `*:0/15`) to run the `git-pages -expire-sites` cleanup job.

        ::: {.note}
        Set to `null` to disable cleanup.

        Existing deployments without expiry set, cannot be made to be expired. Use `allowRetroactiveExpiration` option to allow this.
        :::
      '';
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    allowRetroactiveExpiration = lib.mkOption {
      description = ''
        Enable this to allow expiring old deployments.

        ::: {.note}
        Git-pages doesn't allow by default to set the expiry status of a deployment if it isn't already set to expire.

        Warning, this WILL cause data loss, enable this only if your deployments are backed up or unimportant.
        :::
      '';
      type = lib.types.bool;
      default = false;
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      description = ''
        Settings to set in config.toml.

        ::: {.note}
        See the [git-pages documentation](https://git-pages.org/running-a-server/#configuration) on configuring the server.
        :::
      '';
      default = { };
    };
  };

  config = {
    git-pages.settings.features = lib.mkIf (cfg.cleanupInterval != null) [ "expiration" ];
    git-pages.settings.limits.allow-expiration = lib.mkIf (cfg.cleanupInterval != null) true;
    git-pages.settings.limits.allow-retroactive-expiration = cfg.allowRetroactiveExpiration;
    git-pages.settings.storage.fs.root = lib.mkDefault "/var/lib/${name}/data";

    process.argv = [
      (lib.getExe cfg.package)
      "-config"
      configOutPath
    ];

    configData."${configFile}".source = settingsFormat.generate configFile cfg.settings;
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.service = {
      description = "Forge-agnostic static site server";
      documentation = [ "https://git-pages.org/running-a-server/" ];

      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.configData."${configFile}".source ];

      serviceConfig = {
        Restart = "always";

        StateDirectory = name;
        WorkingDirectory = "%S/${name}";
        BindReadOnlyPaths = [ configOutPath ];

        LoadCredential = lib.optional (cfg.secretFile != null) "secrets.toml:${cfg.secretFile}";

        User = name;
        DynamicUser = true;
      }
      // hardeningOptions;
    };

    systemd.services.expire = lib.mkIf (cfg.cleanupInterval != null) {
      description = "git-pages expire sites job";
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe cfg.package} -config ${configOutPath} -expire-sites";

        WorkingDirectory = "%S/${name}";
        StateDirectory = name;
        BindReadOnlyPaths = [ configOutPath ];

        LoadCredential = lib.optional (cfg.secretFile != null) "secrets.toml:${cfg.secretFile}";

        User = name;
        DynamicUser = true;
      }
      // hardeningOptions;
    };

    systemd.timers.expire = lib.mkIf (cfg.cleanupInterval != null) {
      description = "git-pages expire sites timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.cleanupInterval;
        Persistent = true;
      };
    };
  };
}
