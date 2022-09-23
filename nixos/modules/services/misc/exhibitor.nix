{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.exhibitor;
  opt = options.services.exhibitor;
  exhibitorConfig = ''
    zookeeper-install-directory=${cfg.baseDir}/zookeeper
    zookeeper-data-directory=${cfg.zkDataDir}
    zookeeper-log-directory=${cfg.zkLogDir}
    zoo-cfg-extra=${cfg.zkExtraCfg}
    client-port=${toString cfg.zkClientPort}
    connect-port=${toString cfg.zkConnectPort}
    election-port=${toString cfg.zkElectionPort}
    cleanup-period-ms=${toString cfg.zkCleanupPeriod}
    servers-spec=${concatStringsSep "," cfg.zkServersSpec}
    auto-manage-instances=${toString cfg.autoManageInstances}
    ${cfg.extraConf}
  '';
  # NB: toString rather than lib.boolToString on cfg.autoManageInstances is intended.
  # Exhibitor tests if it's an integer not equal to 0, so the empty string (toString false)
  # will operate in the same fashion as a 0.
  configDir = pkgs.writeTextDir "exhibitor.properties" exhibitorConfig;
  cliOptionsCommon = {
    configtype = cfg.configType;
    defaultconfig = "${configDir}/exhibitor.properties";
    port = toString cfg.port;
    hostname = cfg.hostname;
    headingtext = if (cfg.headingText != null) then (lib.escapeShellArg cfg.headingText) else null;
    nodemodification = lib.boolToString cfg.nodeModification;
    configcheckms = toString cfg.configCheckMs;
    jquerystyle = cfg.jqueryStyle;
    loglines = toString cfg.logLines;
    servo = lib.boolToString cfg.servo;
    timeout = toString cfg.timeout;
  };
  s3CommonOptions = { s3region = cfg.s3Region; s3credentials = cfg.s3Credentials; };
  cliOptionsPerConfig = {
    s3 = {
      s3config = "${cfg.s3Config.bucketName}:${cfg.s3Config.objectKey}";
      s3configprefix = cfg.s3Config.configPrefix;
    };
    zookeeper = {
      zkconfigconnect = concatStringsSep "," cfg.zkConfigConnect;
      zkconfigexhibitorpath = cfg.zkConfigExhibitorPath;
      zkconfigpollms = toString cfg.zkConfigPollMs;
      zkconfigretry = "${toString cfg.zkConfigRetry.sleepMs}:${toString cfg.zkConfigRetry.retryQuantity}";
      zkconfigzpath = cfg.zkConfigZPath;
      zkconfigexhibitorport = toString cfg.zkConfigExhibitorPort; # NB: This might be null
    };
    file = {
      fsconfigdir = cfg.fsConfigDir;
      fsconfiglockprefix = cfg.fsConfigLockPrefix;
      fsConfigName = fsConfigName;
    };
    none = {
      noneconfigdir = configDir;
    };
  };
  cliOptions = concatStringsSep " " (mapAttrsToList (k: v: "--${k} ${v}") (filterAttrs (k: v: v != null && v != "") (cliOptionsCommon //
               cliOptionsPerConfig.${cfg.configType} //
               s3CommonOptions //
               optionalAttrs cfg.s3Backup { s3backup = "true"; } //
               optionalAttrs cfg.fileSystemBackup { filesystembackup = "true"; }
               )));
in
{
  options = {
    services.exhibitor = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the exhibitor server.
        '';
      };
      # See https://github.com/soabase/exhibitor/wiki/Running-Exhibitor for what these mean
      # General options for any type of config
      port = mkOption {
        type = types.int;
        default = 8080;
        description = lib.mdDoc ''
          The port for exhibitor to listen on and communicate with other exhibitors.
        '';
      };
      baseDir = mkOption {
        type = types.str;
        default = "/var/exhibitor";
        description = lib.mdDoc ''
          Baseline directory for exhibitor runtime config.
        '';
      };
      configType = mkOption {
        type = types.enum [ "file" "s3" "zookeeper" "none" ];
        description = lib.mdDoc ''
          Which configuration type you want to use. Additional config will be
          required depending on which type you are using.
        '';
      };
      hostname = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          Hostname to use and advertise
        '';
        default = null;
      };
      nodeModification = mkOption {
        type = types.bool;
        description = lib.mdDoc ''
          Whether the Explorer UI will allow nodes to be modified (use with caution).
        '';
        default = true;
      };
      configCheckMs = mkOption {
        type = types.int;
        description = lib.mdDoc ''
          Period (ms) to check for shared config updates.
        '';
        default = 30000;
      };
      headingText = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          Extra text to display in UI header
        '';
        default = null;
      };
      jqueryStyle = mkOption {
        type = types.enum [ "red" "black" "custom" ];
        description = lib.mdDoc ''
          Styling used for the JQuery-based UI.
        '';
        default = "red";
      };
      logLines = mkOption {
        type = types.int;
        description = lib.mdDoc ''
        Max lines of logging to keep in memory for display.
        '';
        default = 1000;
      };
      servo = mkOption {
        type = types.bool;
        description = lib.mdDoc ''
          ZooKeeper will be queried once a minute for its state via the 'mntr' four
          letter word (this requires ZooKeeper 3.4.x+). Servo will be used to publish
          this data via JMX.
        '';
        default = false;
      };
      timeout = mkOption {
        type = types.int;
        description = lib.mdDoc ''
          Connection timeout (ms) for ZK connections.
        '';
        default = 30000;
      };
      autoManageInstances = mkOption {
        type = types.bool;
        description = lib.mdDoc ''
          Automatically manage ZooKeeper instances in the ensemble
        '';
        default = false;
      };
      zkDataDir = mkOption {
        type = types.str;
        default = "${cfg.baseDir}/zkData";
        defaultText = literalExpression ''"''${config.${opt.baseDir}}/zkData"'';
        description = lib.mdDoc ''
          The Zookeeper data directory
        '';
      };
      zkLogDir = mkOption {
        type = types.path;
        default = "${cfg.baseDir}/zkLogs";
        defaultText = literalExpression ''"''${config.${opt.baseDir}}/zkLogs"'';
        description = lib.mdDoc ''
          The Zookeeper logs directory
        '';
      };
      extraConf = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Extra Exhibitor configuration to put in the ZooKeeper config file.
        '';
      };
      zkExtraCfg = mkOption {
        type = types.str;
        default = "initLimit=5&syncLimit=2&tickTime=2000";
        description = lib.mdDoc ''
          Extra options to pass into Zookeeper
        '';
      };
      zkClientPort = mkOption {
        type = types.int;
        default = 2181;
        description = lib.mdDoc ''
          Zookeeper client port
        '';
      };
      zkConnectPort = mkOption {
        type = types.int;
        default = 2888;
        description = lib.mdDoc ''
          The port to use for followers to talk to each other.
        '';
      };
      zkElectionPort = mkOption {
        type = types.int;
        default = 3888;
        description = lib.mdDoc ''
          The port for Zookeepers to use for leader election.
        '';
      };
      zkCleanupPeriod = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          How often (in milliseconds) to run the Zookeeper log cleanup task.
        '';
      };
      zkServersSpec = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Zookeeper server spec for all servers in the ensemble.
        '';
        example = [ "S:1:zk1.example.com" "S:2:zk2.example.com" "S:3:zk3.example.com" "O:4:zk-observer.example.com" ];
      };

      # Backup options
      s3Backup = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable backups to S3
        '';
      };
      fileSystemBackup = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enables file system backup of ZooKeeper log files
        '';
      };

      # Options for using zookeeper configType
      zkConfigConnect = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc ''
          The initial connection string for ZooKeeper shared config storage
        '';
        example = ["host1:2181" "host2:2181"];
      };
      zkConfigExhibitorPath = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          If the ZooKeeper shared config is also running Exhibitor, the URI path for the REST call
        '';
        default = "/";
      };
      zkConfigExhibitorPort = mkOption {
        type = types.nullOr types.int;
        description = lib.mdDoc ''
          If the ZooKeeper shared config is also running Exhibitor, the port that
          Exhibitor is listening on. IMPORTANT: if this value is not set it implies
          that Exhibitor is not being used on the ZooKeeper shared config.
        '';
      };
      zkConfigPollMs = mkOption {
        type = types.int;
        description = lib.mdDoc ''
          The period in ms to check for changes in the config ensemble
        '';
        default = 10000;
      };
      zkConfigRetry = {
        sleepMs = mkOption {
          type = types.int;
          default = 1000;
          description = lib.mdDoc ''
            Retry sleep time connecting to the ZooKeeper config
          '';
        };
        retryQuantity = mkOption {
          type = types.int;
          default = 3;
          description = lib.mdDoc ''
            Retries connecting to the ZooKeeper config
          '';
        };
      };
      zkConfigZPath = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The base ZPath that Exhibitor should use
        '';
        example = "/exhibitor/config";
      };

      # Config options for s3 configType
      s3Config = {
        bucketName = mkOption {
          type = types.str;
          description = lib.mdDoc ''
            Bucket name to store config
          '';
        };
        objectKey = mkOption {
          type = types.str;
          description = lib.mdDoc ''
            S3 key name to store the config
          '';
        };
        configPrefix = mkOption {
          type = types.str;
          description = lib.mdDoc ''
            When using AWS S3 shared config files, the prefix to use for values such as locks
          '';
          default = "exhibitor-";
        };
      };

      # The next two are used for either s3backup or s3 configType
      s3Credentials = mkOption {
        type = types.nullOr types.path;
        description = lib.mdDoc ''
          Optional credentials to use for s3backup or s3config. Argument is the path
          to an AWS credential properties file with two properties:
          com.netflix.exhibitor.s3.access-key-id and com.netflix.exhibitor.s3.access-secret-key
        '';
        default = null;
      };
      s3Region = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          Optional region for S3 calls
        '';
        default = null;
      };

      # Config options for file config type
      fsConfigDir = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          Directory to store Exhibitor properties (cannot be used with s3config).
          Exhibitor uses file system locks so you can specify a shared location
          so as to enable complete ensemble management.
        '';
      };
      fsConfigLockPrefix = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          A prefix for a locking mechanism used in conjunction with fsconfigdir
        '';
        default = "exhibitor-lock-";
      };
      fsConfigName = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The name of the file to store config in
        '';
        default = "exhibitor.properties";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.exhibitor = {
      description = "Exhibitor Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        ZOO_LOG_DIR = cfg.baseDir;
      };
      serviceConfig = {
        /***
          Exhibitor is a bit un-nixy. It wants to present to you a user interface in order to
          mutate the configuration of both itself and ZooKeeper, and to coordinate changes
          among the members of the Zookeeper ensemble. I'm going for a different approach here,
          which is to manage all the configuration via nix and have it write out the configuration
          files that exhibitor will use, and to reduce the amount of inter-exhibitor orchestration.
        ***/
        ExecStart = ''
          ${pkgs.exhibitor}/bin/startExhibitor.sh ${cliOptions}
        '';
        User = "zookeeper";
        PermissionsStartOnly = true;
      };
      # This is a bit wonky, but the reason for this is that Exhibitor tries to write to
      # ${cfg.baseDir}/zookeeper/bin/../conf/zoo.cfg
      # I want everything but the conf directory to be in the immutable nix store, and I want defaults
      # from the nix store
      # If I symlink the bin directory in, then bin/../ will resolve to the parent of the symlink in the
      # immutable nix store. Bind mounting a writable conf over the existing conf might work, but it gets very
      # messy with trying to copy the existing out into a mutable store.
      # Another option is to try to patch upstream exhibitor, but the current package just pulls down the
      # prebuild JARs off of Maven, rather than building them ourselves, as Maven support in Nix isn't
      # very mature. So, it seems like a reasonable compromise is to just copy out of the immutable store
      # just before starting the service, so we're running binaries from the immutable store, but we work around
      # Exhibitor's desire to mutate its current installation.
      preStart = ''
        mkdir -m 0700 -p ${cfg.baseDir}/zookeeper
        # Not doing a chown -R to keep the base ZK files owned by root
        chown zookeeper ${cfg.baseDir} ${cfg.baseDir}/zookeeper
        cp -Rf ${pkgs.zookeeper}/* ${cfg.baseDir}/zookeeper
        chown -R zookeeper ${cfg.baseDir}/zookeeper/conf
        chmod -R u+w ${cfg.baseDir}/zookeeper/conf
        replace_what=$(echo ${pkgs.zookeeper} | sed 's/[\/&]/\\&/g')
        replace_with=$(echo ${cfg.baseDir}/zookeeper | sed 's/[\/&]/\\&/g')
        sed -i 's/'"$replace_what"'/'"$replace_with"'/g' ${cfg.baseDir}/zookeeper/bin/zk*.sh
      '';
    };
    users.users.zookeeper = {
      uid = config.ids.uids.zookeeper;
      description = "Zookeeper daemon user";
      home = cfg.baseDir;
    };
  };
}
