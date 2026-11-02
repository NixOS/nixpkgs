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
    };
  };
}
