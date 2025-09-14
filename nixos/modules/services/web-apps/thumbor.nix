{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.thumbor;
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

    pythonConfig = mkOption {
      type = types.str;
      default = "";
      description = ''
        The contents of the configuration file, as Python code.

        Do not put your keyfile in here! Use the `keyFile` option.
      '';
      example = ''
        import os

        ACCESS_CONTROL_ALLOW_ORIGIN_HEADER = os.environ["THUMBOR_ACCESS_CONTROL_ALLOW_ORIGIN_HEADER"]
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
  };

  meta.maintainers = [ lib.maintainers.sephi ];

  config = lib.mkIf cfg.enable ({
    users.groups.thumbor = { };
    users.users.thumbor = {
      group = "thumbor";
      isSystemUser = true;
    };

    systemd.services.thumbor = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        let
          configFile = pkgs.writeText "thumbor_config.py" cfg.pythonConfig;

          startOptions = [
            "-c ${configFile}"
            "-l ${cfg.logLevel}"
            "-i ${cfg.listenAddress}"
            "-p ${toString cfg.port}"
            "--processes ${toString cfg.processes}"
          ]
          ++ lib.optional (cfg.fileDescriptor != null) "-f ${cfg.fileDescriptor}"
          ++ lib.optional (cfg.keyFile != null) "-k ${cfg.keyFile}"
          ++ lib.optional cfg.debug "-d";
        in
        {
          ExecStart = ''${lib.getExe cfg.package} ${lib.concatStringsSep " " startOptions}'';
          User = "thumbor";
          Group = "thumbor";
          PrivateTmp = "true";
        };
    };
  });
}
