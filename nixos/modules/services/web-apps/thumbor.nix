{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.thumbor;

  settingsFormat = pkgs.formats.pythonVars { };
in
{

  options.services.thumbor = with lib; {
    enable = mkEnableOption "thumbor";

    package = mkPackageOption pkgs "thumbor" { };

    port = mkOption {
      type = types.port;
      default = 8888;
      description = ''
        The port Thumbor listens to.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        The address Thumbor listens to.
      '';
    };

    fileDescriptor = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The file descriptor number or path to Unix socket to listen for connections on (`port` and `listenAddress` will be ignored if this option is set).
      '';
    };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        Configuration for thumbor.

        See <https://github.com/thumbor/thumbor/blob/master/thumbor/config.py> for available options.

        ::: {.warning}
        Do not put your keyfile in here! Use the `keyFile` option.
        :::
      '';
      example = lib.literalExpression ''
        let
          format = pkgs.formats.pythonVars { };
        in {
          _includes = [ "os" ];

          ACCESS_CONTROL_ALLOW_ORIGIN_HEADER = format.lib.mkRaw "os.environ[\"THUMBOR_ACCESS_CONTROL_ALLOW_ORIGIN_HEADER\"]";
        }
      '';
    };

    keyFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The path to the secret key file used to sign URLs.
      '';
    };

    logLevel = mkOption {
      type = types.enum [
        "debug"
        "info"
        "warning"
        "error"
        "critical"
        "notset"
      ];
      default = "warning";
      description = ''
        The level of messages to log.
      '';
    };

    debug = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable debug mode.
      '';
    };

    processes = mkOption {
      type = types.ints.unsigned;
      default = 1;
      description = ''
        Number of processes to start. Set to 0 to start a number of processes equal to the number of CPU cores.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        File with environment variables to pass to thumbor, in the format used
        by Systemd EnvironmentFile (`VAR=value` entries, separated by
        newlines). Values in this file will override any configuration set in
        `settings`.
      '';
    };
  };

  meta.maintainers = [ lib.maintainers.sephi ];

  config = lib.mkIf cfg.enable {
    users.groups.thumbor = { };
    users.users.thumbor = {
      group = "thumbor";
      isSystemUser = true;
    };

    systemd.services.thumbor = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        let
          configFile = settingsFormat.generate "thumbor_config.py" cfg.settings;

          startOptions = lib.cli.toGNUCommandLineShell { } {
            c = configFile;
            l = cfg.logLevel;
            i = cfg.listenAddress;
            p = cfg.port;
            f = cfg.fileDescriptor;
            k = cfg.keyFile;
            d = cfg.debug;
            processes = cfg.processes;
          };
        in
        {
          ExecStart = ''${lib.getExe cfg.package} --use-environment 1 ${startOptions}'';
          EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          User = "thumbor";
          Group = "thumbor";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectKernelTunables = true;
          ProtectSystem = "full";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
        };
    };
  };
}
