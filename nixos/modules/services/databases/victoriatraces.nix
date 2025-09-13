{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  inherit (lib)
    escapeShellArgs
    getBin
    hasPrefix
    literalExpression
    mkBefore
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalString
    types
    ;
  cfg = config.services.victoriatraces;
  startCLIList = [
    "${cfg.package}/bin/victoria-traces"
    "-storageDataPath=/var/lib/${cfg.stateDir}"
    "-httpListenAddr=${cfg.listenAddress}"
  ]
  ++ lib.optionals (cfg.basicAuthUsername != null) [
    "-httpAuth.username=${cfg.basicAuthUsername}"
  ]
  ++ lib.optionals (cfg.basicAuthPasswordFile != null) [
    "-httpAuth.password=file://%d/basic_auth_password"
  ];
in
{
  options.services.victoriatraces = {
    enable = mkEnableOption "VictoriaTraces is an open source distributed traces storage and query engine from VictoriaMetrics";
    package = mkPackageOption pkgs "victoriatraces" { };
    listenAddress = mkOption {
      default = ":10428";
      type = types.str;
      description = ''
        TCP address to listen for incoming http requests.
      '';
    };
    stateDir = mkOption {
      type = types.str;
      default = "victoriatraces";
      description = ''
        Directory below `/var/lib` to store VictoriaTraces data.
        This directory will be created automatically using systemd's StateDirectory mechanism.
      '';
    };
    retentionPeriod = mkOption {
      type = types.str;
      default = "7d";
      example = "30d";
      description = ''
        Retention period for trace data. Data older than retentionPeriod is automatically deleted.
      '';
    };
    basicAuthUsername = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = ''
        Basic Auth username used to protect VictoriaTraces instance by authorization
      '';
    };

    basicAuthPasswordFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = ''
        File that contains the Basic Auth password used to protect VictoriaTraces instance by authorization
      '';
    };
    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = literalExpression ''
        [
          "-loggerLevel=WARN"
          "-retention.maxDiskSpaceUsageBytes=1073741824"
        ]
      '';
      description = ''
        Extra options to pass to VictoriaTraces. See {command}`victoria-traces -help` for
        possible options.
      '';
    };
  };
  config = mkIf cfg.enable {

    assertions = [
      {
        assertion =
          (cfg.basicAuthUsername == null && cfg.basicAuthPasswordFile == null)
          || (cfg.basicAuthUsername != null && cfg.basicAuthPasswordFile != null);
        message = "Both basicAuthUsername and basicAuthPasswordFile must be set together to enable basicAuth functionality, or neither should be set.";
      }
    ];

    systemd.services.victoriatraces = {
      description = "VictoriaTraces distributed traces database";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      startLimitBurst = 5;

      serviceConfig = {
        ExecStart = lib.concatStringsSep " " [
          (escapeShellArgs (startCLIList ++ [ "-retentionPeriod=${cfg.retentionPeriod}" ]))
          (utils.escapeSystemdExecArgs cfg.extraOptions)
        ];
        DynamicUser = true;
        LoadCredential = lib.optional (
          cfg.basicAuthPasswordFile != null
        ) "basic_auth_password:${cfg.basicAuthPasswordFile}";
        RestartSec = 1;
        Restart = "on-failure";
        RuntimeDirectory = "victoriatraces";
        RuntimeDirectoryMode = "0700";
        StateDirectory = cfg.stateDir;
        StateDirectoryMode = "0700";

        # Increase the limit to avoid errors like 'too many open files' when handling many trace spans
        LimitNOFILE = 1048576;

        # Hardening
        DeviceAllow = [ "/dev/null rw" ];
        DevicePolicy = "strict";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      };

      postStart =
        let
          bindAddr = (optionalString (hasPrefix ":" cfg.listenAddress) "127.0.0.1") + cfg.listenAddress;
        in
        mkBefore ''
          until ${getBin pkgs.curl}/bin/curl -s -o /dev/null http://${bindAddr}/ping; do
            sleep 1;
          done
        '';
    };
  };
}
