{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xtreemfs;

  xtreemfs = pkgs.xtreemfs;

  home = cfg.homeDir;

  startupScript = class: configPath: pkgs.writeScript "xtreemfs-osd.sh" ''
    #! ${pkgs.runtimeShell}
    JAVA_HOME="${pkgs.jdk}"
    JAVADIR="${xtreemfs}/share/java"
    JAVA_CALL="$JAVA_HOME/bin/java -ea -cp $JAVADIR/XtreemFS.jar:$JAVADIR/BabuDB.jar:$JAVADIR/Flease.jar:$JAVADIR/protobuf-java-2.5.0.jar:$JAVADIR/Foundation.jar:$JAVADIR/jdmkrt.jar:$JAVADIR/jdmktk.jar:$JAVADIR/commons-codec-1.3.jar"
    $JAVA_CALL ${class} ${configPath}
  '';

  dirReplicationConfig = pkgs.writeText "xtreemfs-dir-replication-plugin.properties" ''
    babudb.repl.backupDir = ${home}/server-repl-dir
    plugin.jar = ${xtreemfs}/share/java/BabuDB_replication_plugin.jar
    babudb.repl.dependency.0 = ${xtreemfs}/share/java/Flease.jar

    ${cfg.dir.replication.extraConfig}
  '';

  dirConfig = pkgs.writeText "xtreemfs-dir-config.properties" ''
    uuid = ${cfg.dir.uuid}
    listen.port = ${toString cfg.dir.port}
    ${optionalString (cfg.dir.address != "") "listen.address = ${cfg.dir.address}"}
    http_port = ${toString cfg.dir.httpPort}
    babudb.baseDir = ${home}/dir/database
    babudb.logDir = ${home}/dir/db-log
    babudb.sync = ${if cfg.dir.replication.enable then "FDATASYNC" else cfg.dir.syncMode}

    ${optionalString cfg.dir.replication.enable "babudb.plugin.0 = ${dirReplicationConfig}"}

    ${cfg.dir.extraConfig}
  '';

  mrcReplicationConfig = pkgs.writeText "xtreemfs-mrc-replication-plugin.properties" ''
    babudb.repl.backupDir = ${home}/server-repl-mrc
    plugin.jar = ${xtreemfs}/share/java/BabuDB_replication_plugin.jar
    babudb.repl.dependency.0 = ${xtreemfs}/share/java/Flease.jar

    ${cfg.mrc.replication.extraConfig}
  '';

  mrcConfig = pkgs.writeText "xtreemfs-mrc-config.properties" ''
    uuid = ${cfg.mrc.uuid}
    listen.port = ${toString cfg.mrc.port}
    ${optionalString (cfg.mrc.address != "") "listen.address = ${cfg.mrc.address}"}
    http_port = ${toString cfg.mrc.httpPort}
    babudb.baseDir = ${home}/mrc/database
    babudb.logDir = ${home}/mrc/db-log
    babudb.sync = ${if cfg.mrc.replication.enable then "FDATASYNC" else cfg.mrc.syncMode}

    ${optionalString cfg.mrc.replication.enable "babudb.plugin.0 = ${mrcReplicationConfig}"}

    ${cfg.mrc.extraConfig}
  '';

  osdConfig = pkgs.writeText "xtreemfs-osd-config.properties" ''
    uuid = ${cfg.osd.uuid}
    listen.port = ${toString cfg.osd.port}
    ${optionalString (cfg.osd.address != "") "listen.address = ${cfg.osd.address}"}
    http_port = ${toString cfg.osd.httpPort}
    object_dir = ${home}/osd/

    ${cfg.osd.extraConfig}
  '';

  optionalDir = optionals cfg.dir.enable ["xtreemfs-dir.service"];

  systemdOptionalDependencies = {
    after = [ "network.target" ] ++ optionalDir;
    wantedBy = [ "multi-user.target" ] ++ optionalDir;
  };

in

{

  ###### interface

  options = {

    services.xtreemfs = {

      enable = mkEnableOption "XtreemFS";

      homeDir = mkOption {
        default = "/var/lib/xtreemfs";
        description = ''
          XtreemFS home dir for the xtreemfs user.
        '';
      };

      dir = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to enable XtreemFS DIR service.
          '';
        };

        uuid = mkOption {
          example = "eacb6bab-f444-4ebf-a06a-3f72d7465e40";
          description = ''
            Must be set to a unique identifier, preferably a UUID according to
            RFC 4122. UUIDs can be generated with `uuidgen` command, found in
            the `utillinux` package.
          '';
        };
        port = mkOption {
          default = 32638;
          description = ''
            The port to listen on for incoming connections (TCP).
          '';
        };
        address = mkOption {
          example = "127.0.0.1";
          default = "";
          description = ''
            If specified, it defines the interface to listen on. If not
            specified, the service will listen on all interfaces (any).
          '';
        };
        httpPort = mkOption {
          default = 30638;
          description = ''
            Specifies the listen port for the HTTP service that returns the
            status page.
          '';
        };
        syncMode = mkOption {
          default = "FSYNC";
          example = "FDATASYNC";
          description = ''
            The sync mode influences how operations are committed to the disk
            log before the operation is acknowledged to the caller.

            -ASYNC mode the writes to the disk log are buffered in memory by the operating system. This is the fastest mode but will lead to data loss in case of a crash, kernel panic or power failure.
            -SYNC_WRITE_METADATA opens the file with O_SYNC, the system will not buffer any writes. The operation will be acknowledged when data has been safely written to disk. This mode is slow but offers maximum data safety. However, BabuDB cannot influence the disk drive caches, this depends on the OS and hard disk model.
            -SYNC_WRITE similar to SYNC_WRITE_METADATA but opens file with O_DSYNC which means that only the data is commit to disk. This can lead to some data loss depending on the implementation of the underlying file system. Linux does not implement this mode.
            -FDATASYNC is similar to SYNC_WRITE but opens the file in asynchronous mode and calls fdatasync() after writing the data to disk.
            -FSYNC is similar to SYNC_WRITE_METADATA but opens the file in asynchronous mode and calls fsync() after writing the data to disk.

            For best throughput use ASYNC, for maximum data safety use FSYNC.

            (If xtreemfs.dir.replication.enable is true then FDATASYNC is forced)
          '';
        };
        extraConfig = mkOption {
          type = types.lines;
          default = "";
          example = ''
            # specify whether SSL is required
            ssl.enabled = true
            ssl.service_creds.pw = passphrase
            ssl.service_creds.container = pkcs12
            ssl.service_creds = /etc/xos/xtreemfs/truststore/certs/dir.p12
            ssl.trusted_certs = /etc/xos/xtreemfs/truststore/certs/trusted.jks
            ssl.trusted_certs.pw = jks_passphrase
            ssl.trusted_certs.container = jks
          '';
          description = ''
            Configuration of XtreemFS DIR service.
            WARNING: configuration is saved as plaintext inside nix store.
            For more options: http://www.xtreemfs.org/xtfs-guide-1.5.1/index.html
          '';
        };
        replication = {
          enable = mkEnableOption "XtreemFS DIR replication plugin";
          extraConfig = mkOption {
            type = types.lines;
            example = ''
              # participants of the replication including this replica
              babudb.repl.participant.0 = 192.168.0.10
              babudb.repl.participant.0.port = 35676
              babudb.repl.participant.1 = 192.168.0.11
              babudb.repl.participant.1.port = 35676
              babudb.repl.participant.2 = 192.168.0.12
              babudb.repl.participant.2.port = 35676

              # number of servers that at least have to be up to date
              # To have a fault-tolerant system, this value has to be set to the
              # majority of nodes i.e., if you have three replicas, set this to 2
              # Please note that a setup with two nodes provides no fault-tolerance.
              babudb.repl.sync.n = 2

              # specify whether SSL is required
              babudb.ssl.enabled = true

              babudb.ssl.protocol = tlsv12

              # server credentials for SSL handshakes
              babudb.ssl.service_creds = /etc/xos/xtreemfs/truststore/certs/osd.p12
              babudb.ssl.service_creds.pw = passphrase
              babudb.ssl.service_creds.container = pkcs12

              # trusted certificates for SSL handshakes
              babudb.ssl.trusted_certs = /etc/xos/xtreemfs/truststore/certs/trusted.jks
              babudb.ssl.trusted_certs.pw = jks_passphrase
              babudb.ssl.trusted_certs.container = jks

              babudb.ssl.authenticationWithoutEncryption = false
            '';
            description = ''
              Configuration of XtreemFS DIR replication plugin.
              WARNING: configuration is saved as plaintext inside nix store.
              For more options: http://www.xtreemfs.org/xtfs-guide-1.5.1/index.html
            '';
          };
        };
      };

      mrc = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to enable XtreemFS MRC service.
          '';
        };

        uuid = mkOption {
          example = "eacb6bab-f444-4ebf-a06a-3f72d7465e41";
          description = ''
            Must be set to a unique identifier, preferably a UUID according to
            RFC 4122. UUIDs can be generated with `uuidgen` command, found in
            the `utillinux` package.
          '';
        };
        port = mkOption {
          default = 32636;
          description = ''
            The port to listen on for incoming connections (TCP).
          '';
        };
        address = mkOption {
          example = "127.0.0.1";
          default = "";
          description = ''
            If specified, it defines the interface to listen on. If not
            specified, the service will listen on all interfaces (any).
          '';
        };
        httpPort = mkOption {
          default = 30636;
          description = ''
            Specifies the listen port for the HTTP service that returns the
            status page.
          '';
        };
        syncMode = mkOption {
          default = "FSYNC";
          example = "FDATASYNC";
          description = ''
            The sync mode influences how operations are committed to the disk
            log before the operation is acknowledged to the caller.

            -ASYNC mode the writes to the disk log are buffered in memory by the operating system. This is the fastest mode but will lead to data loss in case of a crash, kernel panic or power failure.
            -SYNC_WRITE_METADATA opens the file with O_SYNC, the system will not buffer any writes. The operation will be acknowledged when data has been safely written to disk. This mode is slow but offers maximum data safety. However, BabuDB cannot influence the disk drive caches, this depends on the OS and hard disk model.
            -SYNC_WRITE similar to SYNC_WRITE_METADATA but opens file with O_DSYNC which means that only the data is commit to disk. This can lead to some data loss depending on the implementation of the underlying file system. Linux does not implement this mode.
            -FDATASYNC is similar to SYNC_WRITE but opens the file in asynchronous mode and calls fdatasync() after writing the data to disk.
            -FSYNC is similar to SYNC_WRITE_METADATA but opens the file in asynchronous mode and calls fsync() after writing the data to disk.

            For best throughput use ASYNC, for maximum data safety use FSYNC.

            (If xtreemfs.mrc.replication.enable is true then FDATASYNC is forced)
          '';
        };
        extraConfig = mkOption {
          type = types.lines;
          example = ''
            osd_check_interval = 300
            no_atime = true
            local_clock_renewal = 0
            remote_time_sync = 30000
            authentication_provider = org.xtreemfs.common.auth.NullAuthProvider

            # shared secret between the MRC and all OSDs
            capability_secret = iNG8UuQJrJ6XVDTe

            dir_service.host = 192.168.0.10
            dir_service.port = 32638

            # if replication is enabled
            dir_service.1.host = 192.168.0.11
            dir_service.1.port = 32638
            dir_service.2.host = 192.168.0.12
            dir_service.2.port = 32638

            # specify whether SSL is required
            ssl.enabled = true
            ssl.protocol = tlsv12
            ssl.service_creds.pw = passphrase
            ssl.service_creds.container = pkcs12
            ssl.service_creds = /etc/xos/xtreemfs/truststore/certs/mrc.p12
            ssl.trusted_certs = /etc/xos/xtreemfs/truststore/certs/trusted.jks
            ssl.trusted_certs.pw = jks_passphrase
            ssl.trusted_certs.container = jks
          '';
          description = ''
            Configuration of XtreemFS MRC service.
            WARNING: configuration is saved as plaintext inside nix store.
            For more options: http://www.xtreemfs.org/xtfs-guide-1.5.1/index.html
          '';
        };
        replication = {
          enable = mkEnableOption "XtreemFS MRC replication plugin";
          extraConfig = mkOption {
            type = types.lines;
            example = ''
              # participants of the replication including this replica
              babudb.repl.participant.0 = 192.168.0.10
              babudb.repl.participant.0.port = 35678
              babudb.repl.participant.1 = 192.168.0.11
              babudb.repl.participant.1.port = 35678
              babudb.repl.participant.2 = 192.168.0.12
              babudb.repl.participant.2.port = 35678

              # number of servers that at least have to be up to date
              # To have a fault-tolerant system, this value has to be set to the
              # majority of nodes i.e., if you have three replicas, set this to 2
              # Please note that a setup with two nodes provides no fault-tolerance.
              babudb.repl.sync.n = 2

              # specify whether SSL is required
              babudb.ssl.enabled = true

              babudb.ssl.protocol = tlsv12

              # server credentials for SSL handshakes
              babudb.ssl.service_creds = /etc/xos/xtreemfs/truststore/certs/osd.p12
              babudb.ssl.service_creds.pw = passphrase
              babudb.ssl.service_creds.container = pkcs12

              # trusted certificates for SSL handshakes
              babudb.ssl.trusted_certs = /etc/xos/xtreemfs/truststore/certs/trusted.jks
              babudb.ssl.trusted_certs.pw = jks_passphrase
              babudb.ssl.trusted_certs.container = jks

              babudb.ssl.authenticationWithoutEncryption = false
            '';
            description = ''
              Configuration of XtreemFS MRC replication plugin.
              WARNING: configuration is saved as plaintext inside nix store.
              For more options: http://www.xtreemfs.org/xtfs-guide-1.5.1/index.html
            '';
          };
        };
      };

      osd = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to enable XtreemFS OSD service.
          '';
        };

        uuid = mkOption {
          example = "eacb6bab-f444-4ebf-a06a-3f72d7465e42";
          description = ''
            Must be set to a unique identifier, preferably a UUID according to
            RFC 4122. UUIDs can be generated with `uuidgen` command, found in
            the `utillinux` package.
          '';
        };
        port = mkOption {
          default = 32640;
          description = ''
            The port to listen on for incoming connections (TCP and UDP).
          '';
        };
        address = mkOption {
          example = "127.0.0.1";
          default = "";
          description = ''
            If specified, it defines the interface to listen on. If not
            specified, the service will listen on all interfaces (any).
          '';
        };
        httpPort = mkOption {
          default = 30640;
          description = ''
            Specifies the listen port for the HTTP service that returns the
            status page.
          '';
        };
        extraConfig = mkOption {
          type = types.lines;
          example = ''
            local_clock_renewal = 0
            remote_time_sync = 30000
            report_free_space = true
            capability_secret = iNG8UuQJrJ6XVDTe

            dir_service.host = 192.168.0.10
            dir_service.port = 32638

            # if replication is used
            dir_service.1.host = 192.168.0.11
            dir_service.1.port = 32638
            dir_service.2.host = 192.168.0.12
            dir_service.2.port = 32638

            # specify whether SSL is required
            ssl.enabled = true
            ssl.service_creds.pw = passphrase
            ssl.service_creds.container = pkcs12
            ssl.service_creds = /etc/xos/xtreemfs/truststore/certs/osd.p12
            ssl.trusted_certs = /etc/xos/xtreemfs/truststore/certs/trusted.jks
            ssl.trusted_certs.pw = jks_passphrase
            ssl.trusted_certs.container = jks
          '';
          description = ''
            Configuration of XtreemFS OSD service.
            WARNING: configuration is saved as plaintext inside nix store.
            For more options: http://www.xtreemfs.org/xtfs-guide-1.5.1/index.html
          '';
        };
      };
    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ xtreemfs ];

    users.users.xtreemfs =
      { uid = config.ids.uids.xtreemfs;
        description = "XtreemFS user";
        createHome = true;
        home = home;
      };

    users.groups.xtreemfs =
      { gid = config.ids.gids.xtreemfs;
      };

    systemd.services.xtreemfs-dir = mkIf cfg.dir.enable {
      description = "XtreemFS-DIR Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "xtreemfs";
        ExecStart = "${startupScript "org.xtreemfs.dir.DIR" dirConfig}";
      };
    };

    systemd.services.xtreemfs-mrc = mkIf cfg.mrc.enable ({
      description = "XtreemFS-MRC Server";
      serviceConfig = {
        User = "xtreemfs";
        ExecStart = "${startupScript "org.xtreemfs.mrc.MRC" mrcConfig}";
      };
    } // systemdOptionalDependencies);

    systemd.services.xtreemfs-osd = mkIf cfg.osd.enable ({
      description = "XtreemFS-OSD Server";
      serviceConfig = {
        User = "xtreemfs";
        ExecStart = "${startupScript "org.xtreemfs.osd.OSD" osdConfig}";
      };
    } // systemdOptionalDependencies);

  };

}
