{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.urbackup;

  urbackup = cfg.package.override {
    withMountVhd = cfg.mountVhd.enable;
  };

  urbackupsrvWrapper = pkgs.writeShellScriptBin "urbackupsrv" ''
    exec systemd-run \
      --quiet \
      --pipe \
      --pty \
      --wait \
      --collect \
      --property=User=${cfg.user} \
      --property=StateDirectory=urbackup \
      --property=DynamicUser=yes \
      --property=SystemCallFilter=~@setuid \
      --service-type=exec \
      ${urbackup}/bin/urbackupsrv "$@"
  '';
in
{
  options = {
    services.urbackup = {
      enable = lib.mkEnableOption "UrBackup, an easy to setup Open Source client/server backup system";

      mountVhd.enable = lib.mkEnableOption "Enable mounting of VHD files via fuse";

      package = lib.mkPackageOption pkgs "urbackup-server" { };

      fastcgiPort = lib.mkOption {
        type = lib.types.port;
        default = 55413;
        description = "Port for FastCGI requests";
      };

      enableHttpServer = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable internal HTTP server.
          Required for serving web interface without FastCGI
          and for websocket connections from client.
        '';
      };

      httpPort = lib.mkOption {
        type = lib.types.port;
        default = 55414;
        description = "Port for the web interface (if internal HTTP server is enabled)";
      };

      httpLocalhostOnly = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Bind HTTP server to localhost only";
      };

      internetLocalhostOnly = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Bind Internet port to localhost only";
      };

      logFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/log/urbackup/urbackup.log";
        description = "Path to the log file";
      };

      logLevel = lib.mkOption {
        type = lib.types.enum [
          "debug"
          "warn"
          "info"
          "error"
        ];
        default = "warn";
        description = "Logging level (either debug, warn, info or error)";
      };

      daemonTmpDir = lib.mkOption {
        type = lib.types.path;
        default = "/tmp";
        description = ''
          Temporary file directory.
          This may get very large depending on the advanced settings.
        '';
      };

      sqliteTmpDir = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Tmp file directory for sqlite temporary tables.
          You might want to put the databases on another filesystem than the other temporary files.
          Defaults to the same as daemonTmpDir if not specified.
        '';
      };

      broadcastInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Interfaces from which to send broadcasts.
          Empty list means all interfaces.
          Example: ["eth0" "eth1"]
        '';
      };

      allowUserEnumeration = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable better error messages if a user cannot be found during login";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "urbackup";
        description = "User the urbackupsrv process runs as";
      };

      backupStoragePath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Absolute path to backup storage location. This path must exist.
          Note: By default, the service will be restricted to access this path only.
        '';
      };

      dataset = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Create a separate ZFS dataset for storing images.";
      };

      datasetFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Sets the dataset where the copy-on-write file backups are to be stored.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."urbackup/backupfolder" = lib.mkIf (cfg.backupStoragePath != null) {
      text = cfg.backupStoragePath;
    };

    environment.etc."urbackup/dataset" = lib.mkIf (cfg.dataset != null) {
      text = cfg.dataset;
    };

    environment.etc."urbackup/dataset_file" = lib.mkIf (cfg.datasetFile != null) {
      text = cfg.datasetFile;
    };

    environment.etc."urbackup/urbackupsrv".text = ''
      #Port for FastCGI requests
      FASTCGI_PORT=${toString cfg.fastcgiPort}

      #Enable internal HTTP server
      #Required for serving web interface without FastCGI
      #and for websocket connections from client
      HTTP_SERVER="${if cfg.enableHttpServer then "true" else "false"}"

      #Port for the web interface
      #(if internal HTTP server is enabled)
      HTTP_PORT=${toString cfg.httpPort}

      #Bind HTTP server to localhost only
      HTTP_LOCALHOST_ONLY=${if cfg.httpLocalhostOnly then "true" else "false"}

      #Bind Internet port to localhost only
      INTERNET_LOCALHOST_ONLY=${if cfg.internetLocalhostOnly then "true" else "false"}

      #log file name
      LOGFILE="${cfg.logFile}"

      #Either debug,warn,info or error
      LOGLEVEL="${cfg.logLevel}"

      #Temporary file directory
      DAEMON_TMPDIR="${cfg.daemonTmpDir}"

      #Tmp file directory for sqlite temporary tables.
      #You might want to put the databases on another filesystem than the other temporary files.
      #Default is the same as DAEMON_TMPDIR
      SQLITE_TMPDIR="${if cfg.sqliteTmpDir == null then "" else cfg.sqliteTmpDir}"

      #Interfaces from which to send broadcasts. (Default: all).
      #Comma separated -- e.g. "eth0,eth1"
      BROADCAST_INTERFACES="${lib.concatStringsSep "," cfg.broadcastInterfaces}"

      # Enable better error messages if a user cannot be found during login
      ALLOW_USER_ENUMERATION="${if cfg.allowUserEnumeration then "true" else "false"}"

      #User the urbackupsrv process runs as
      USER="${cfg.user}"
    '';

    users = {
      users = lib.mkIf (cfg.user == "urbackup") {
        urbackup = {
          group = "urbackup";
          isSystemUser = true;
        };
      };
      groups = {
        urbackup = { };
      };
    };

    security.wrappers.urbackup_mount_helper = {
      setuid = true;
      owner = cfg.user;
      group = "urbackup";
      source = "${urbackup}/bin/urbackup_mount_helper";
    };

    security.wrappers.urbackup_snapshot_helper = {
      setuid = true;
      owner = cfg.user;
      group = "urbackup";
      source = "${urbackup}/bin/urbackup_snapshot_helper";
    };

    environment.systemPackages = [
      urbackupsrvWrapper
    ] ++ lib.optionals (cfg.mountVhd.enable) [ pkgs.libguestfs ];

    systemd.services.urbackup-server = {
      description = "UrBackup Client/Server Network Backup System";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        StateDirectory = "urbackup";
        LogsDirectory = "urbackup";
        ReadWritePaths =
          [
            cfg.backupStoragePath
          ]
          ++ lib.optionals (cfg.sqliteTmpDir != null) [ cfg.sqliteTmpDir ]
          ++ lib.optionals (cfg.daemonTmpDir != "/tmp") [ cfg.daemonTmpDir ]
          ++ lib.optionals (cfg.logFile != "/var/log/urbackup/urbackup.log") [ cfg.logFile ];
        ExecStart = "${urbackup}/bin/urbackupsrv run --config /etc/urbackup/urbackupsrv --no-consoletime";
        User = cfg.user;
        DynamicUser = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@setuid"
        ];
      };
    };
  };
}
