{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.services.vikunja;
  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" cfg.settings;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "vikunja" "setupNginx" ]
      "services.vikunja no longer supports the automatic set up of a nginx virtual host. Set up your own webserver config with a proxy pass to the vikunja service."
    )
  ];

  options.services.vikunja = {
    enable = lib.mkEnableOption "vikunja service";
    package = lib.mkPackageOption pkgs "vikunja" { };
    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        List of environment files set in the vikunja systemd service.
        For example passwords should be set in one of these files.
      '';
    };
    frontendScheme = lib.mkOption {
      type = lib.types.enum [
        "http"
        "https"
      ];
      default = "http";
      description = ''
        Whether the site is available via http or https.
      '';
    };
    frontendHostname = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "The Hostname under which the frontend is running.";
    };
    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "The IP address to bind to.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3456;
      description = "The TCP port exposed by the API.";
    };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      description = ''
        Vikunja configuration. Refer to
        <https://vikunja.io/docs/config-options/>
        for details on supported values.
      '';
    };
    database = {
      type = lib.mkOption {
        type = lib.types.enum [
          "sqlite"
          "mysql"
          "postgres"
        ];
        example = "postgres";
        default = "sqlite";
        description = "Database engine to use.";
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Database host address. Can also be a socket.";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "vikunja";
        description = "Database user.";
      };
      database = lib.mkOption {
        type = lib.types.str;
        default = "vikunja";
        description = "Database name.";
      };
      path = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/vikunja/vikunja.db";
        description = "Path to the sqlite3 database file.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.vikunja.settings = {
      database = {
        inherit (cfg.database)
          type
          host
          user
          database
          path
          ;
      };
      service = {
        interface = "${cfg.address}:${toString cfg.port}";
        publicurl = "${cfg.frontendScheme}://${cfg.frontendHostname}/";
      };
      files = {
        basepath = "/var/lib/vikunja/files";
      };
    };

    systemd.services.vikunja = {
      description = "vikunja";
      after = [
        "network.target"
      ]
      ++ lib.optional usePostgresql "postgresql.target"
      ++ lib.optional useMysql "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      restartTriggers = [ configFile ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "vikunja";
        StateDirectoryMode = "0750";
        ExecStart = "${cfg.package}/bin/vikunja";
        Restart = "always";
        EnvironmentFile = cfg.environmentFiles;
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SocketBindAllow = [
          "tcp:${toString cfg.port}"
        ];
        SocketBindDeny = "any";
        SystemCallArchitectures = "native";
        UMask = 27;
      };
    };

    environment.etc."vikunja/config.yaml".source = configFile;

    environment.systemPackages = [
      cfg.package # for admin `vikunja` CLI
    ];
  };
}
