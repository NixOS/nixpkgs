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
  cfg = config.services.victorialogs;
  startCLIList = [
    "${cfg.package}/bin/victoria-logs"
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
  options.services.victorialogs = {
    enable = mkEnableOption "VictoriaLogs is an open source user-friendly database for logs from VictoriaMetrics";
    package = mkPackageOption pkgs "victorialogs" { };
    listenAddress = mkOption {
      default = ":9428";
      type = types.str;
      description = ''
        TCP address to listen for incoming http requests.
      '';
    };
    stateDir = mkOption {
      type = types.str;
      default = "victorialogs";
      description = ''
        Directory below `/var/lib` to store VictoriaLogs data.
        This directory will be created automatically using systemd's StateDirectory mechanism.
      '';
    };
    basicAuthUsername = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = ''
        Basic Auth username used to protect VictoriaLogs instance by authorization
      '';
    };

    basicAuthPasswordFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = ''
        File that contains the Basic Auth password used to protect VictoriaLogs instance by authorization
      '';
    };
    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = literalExpression ''
        [
          "-loggerLevel=WARN"
        ]
      '';
      description = ''
        Extra options to pass to VictoriaLogs. See {command}`victoria-logs -help` for
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

    systemd.services.victorialogs = {
      description = "VictoriaLogs logs database";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      startLimitBurst = 5;

      serviceConfig = {
        ExecStart = lib.concatStringsSep " " [
          (escapeShellArgs startCLIList)
          (utils.escapeSystemdExecArgs cfg.extraOptions)
        ];
        DynamicUser = true;
        LoadCredential = lib.optional (
          cfg.basicAuthPasswordFile != null
        ) "basic_auth_password:${cfg.basicAuthPasswordFile}";
        RestartSec = 1;
        Restart = "on-failure";
        RuntimeDirectory = "victorialogs";
        RuntimeDirectoryMode = "0700";
        StateDirectory = cfg.stateDir;
        StateDirectoryMode = "0700";

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
