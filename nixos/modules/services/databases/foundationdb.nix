{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.foundationdb;
  pkg = cfg.package;

  # used for initial cluster configuration
  initialIpAddr = if (cfg.publicAddress != "auto") then cfg.publicAddress else "127.0.0.1";

  fdbServers =
    n:
    lib.concatStringsSep "\n" (
      map (x: "[fdbserver.${toString (x + cfg.listenPortStart)}]") (lib.range 0 (n - 1))
    );

  backupAgents =
    n: lib.concatStringsSep "\n" (map (x: "[backup_agent.${toString x}]") (lib.range 1 n));

  configFile = pkgs.writeText "foundationdb.conf" ''
    [general]
    cluster_file  = /etc/foundationdb/fdb.cluster

    [fdbmonitor]
    restart_delay = ${toString cfg.restartDelay}
    user          = ${cfg.user}
    group         = ${cfg.group}

    [fdbserver]
    command        = ${pkg}/bin/fdbserver
    public_address = ${cfg.publicAddress}:$ID
    listen_address = ${cfg.listenAddress}
    datadir        = ${cfg.dataDir}/$ID
    logdir         = ${cfg.logDir}
    logsize        = ${cfg.logSize}
    maxlogssize    = ${cfg.maxLogSize}
    ${lib.optionalString (cfg.class != null) "class = ${cfg.class}"}
    memory         = ${cfg.memory}
    storage_memory = ${cfg.storageMemory}

    ${lib.optionalString (lib.versionAtLeast cfg.package.version "6.1") ''
      trace_format   = ${cfg.traceFormat}
    ''}

    ${lib.optionalString (cfg.tls != null) ''
      tls_plugin           = ${pkg}/libexec/plugins/FDBLibTLS.so
      tls_certificate_file = ${cfg.tls.certificate}
      tls_key_file         = ${cfg.tls.key}
      tls_verify_peers     = ${cfg.tls.allowedPeers}
    ''}

    ${lib.optionalString (
      cfg.locality.machineId != null
    ) "locality_machineid=${cfg.locality.machineId}"}
    ${lib.optionalString (cfg.locality.zoneId != null) "locality_zoneid=${cfg.locality.zoneId}"}
    ${lib.optionalString (
      cfg.locality.datacenterId != null
    ) "locality_dcid=${cfg.locality.datacenterId}"}
    ${lib.optionalString (cfg.locality.dataHall != null) "locality_data_hall=${cfg.locality.dataHall}"}

    ${fdbServers cfg.serverProcesses}

    [backup_agent]
    command = ${pkg}/libexec/backup_agent
    ${backupAgents cfg.backupProcesses}
  '';
in
{
  options.services.foundationdb = {

    enable = lib.mkEnableOption "FoundationDB Server";

    package = lib.mkOption {
      type = lib.types.package;
      description = ''
        The FoundationDB package to use for this server. This must be specified by the user
        in order to ensure migrations and upgrades are controlled appropriately.
      '';
    };

    publicAddress = lib.mkOption {
      type = lib.types.str;
      default = "auto";
      description = "Publicly visible IP address of the process. Port is determined by process ID";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "public";
      description = "Publicly visible IP address of the process. Port is determined by process ID";
    };

    listenPortStart = lib.mkOption {
      type = lib.types.port;
      default = 4500;
      description = ''
        Starting port number for database listening sockets. Every FDB process binds to a
        subsequent port, to this number reflects the start of the overall range. e.g. having
        8 server processes will use all ports between 4500 and 4507.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open the firewall ports corresponding to FoundationDB processes and coordinators
        using {option}`config.networking.firewall.*`.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/foundationdb";
      description = "Data directory. All cluster data will be put under here.";
    };

    logDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/log/foundationdb";
      description = "Log directory.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "foundationdb";
      description = "User account under which FoundationDB runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "foundationdb";
      description = "Group account under which FoundationDB runs.";
    };

    class = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "storage"
          "transaction"
          "stateless"
        ]
      );
      default = null;
      description = "Process class";
    };

    restartDelay = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Number of seconds to wait before restarting servers.";
    };

    logSize = lib.mkOption {
      type = lib.types.str;
      default = "10MiB";
      description = ''
        Roll over to a new log file after the current log file
        reaches the specified size.
      '';
    };

    maxLogSize = lib.mkOption {
      type = lib.types.str;
      default = "100MiB";
      description = ''
        Delete the oldest log file when the total size of all log
        files exceeds the specified size. If set to 0, old log files
        will not be deleted.
      '';
    };

    serverProcesses = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Number of fdbserver processes to run.";
    };

    backupProcesses = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Number of backup_agent processes to run for snapshots.";
    };

    memory = lib.mkOption {
      type = lib.types.str;
      default = "8GiB";
      description = ''
        Maximum memory used by the process. The default value is
        `8GiB`. When specified without a unit,
        `MiB` is assumed. This parameter does not
        change the memory allocation of the program. Rather, it sets
        a hard limit beyond which the process will kill itself and
        be restarted. The default value of `8GiB`
        is double the intended memory usage in the default
        configuration (providing an emergency buffer to deal with
        memory leaks or similar problems). It is not recommended to
        decrease the value of this parameter below its default
        value. It may be increased if you wish to allocate a very
        large amount of storage engine memory or cache. In
        particular, when the `storageMemory`
        parameter is increased, the `memory`
        parameter should be increased by an equal amount.
      '';
    };

    storageMemory = lib.mkOption {
      type = lib.types.str;
      default = "1GiB";
      description = ''
        Maximum memory used for data storage. The default value is
        `1GiB`. When specified without a unit,
        `MB` is assumed. Clusters using the memory
        storage engine will be restricted to using this amount of
        memory per process for purposes of data storage. Memory
        overhead associated with storing the data is counted against
        this total. If you increase the
        `storageMemory`, you should also increase
        the `memory` parameter by the same amount.
      '';
    };

    tls = lib.mkOption {
      default = null;
      description = ''
        FoundationDB Transport Security Layer (TLS) settings.
      '';

      type = lib.types.nullOr (
        lib.types.submodule ({
          options = {
            certificate = lib.mkOption {
              type = lib.types.str;
              description = ''
                Path to the TLS certificate file. This certificate will
                be offered to, and may be verified by, clients.
              '';
            };

            key = lib.mkOption {
              type = lib.types.str;
              description = "Private key file for the certificate.";
            };

            allowedPeers = lib.mkOption {
              type = lib.types.str;
              default = "Check.Valid=1,Check.Unexpired=1";
              description = ''
                "Peer verification string". This may be used to adjust which TLS
                client certificates a server will accept, as a form of user
                authorization; for example, it may only accept TLS clients who
                offer a certificate abiding by some locality or organization name.

                For more information, please see the FoundationDB documentation.
              '';
            };
          };
        })
      );
    };

    locality = lib.mkOption {
      default = {
        machineId = null;
        zoneId = null;
        datacenterId = null;
        dataHall = null;
      };

      description = ''
        FoundationDB locality settings.
      '';

      type = lib.types.submodule ({
        options = {
          machineId = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.str;
            description = ''
              Machine identifier key. All processes on a machine should share a
              unique id. By default, processes on a machine determine a unique id to share.
              This does not generally need to be set.
            '';
          };

          zoneId = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.str;
            description = ''
              Zone identifier key. Processes that share a zone id are
              considered non-unique for the purposes of data replication.
              If unset, defaults to machine id.
            '';
          };

          datacenterId = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.str;
            description = ''
              Data center identifier key. All processes physically located in a
              data center should share the id. If you are depending on data
              center based replication this must be set on all processes.
            '';
          };

          dataHall = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.str;
            description = ''
              Data hall identifier key. All processes physically located in a
              data hall should share the id. If you are depending on data
              hall based replication this must be set on all processes.
            '';
          };
        };
      });
    };

    extraReadWritePaths = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.path;
      description = ''
        An extra set of filesystem paths that FoundationDB can read to
        and write from. By default, FoundationDB runs under a heavily
        namespaced systemd environment without write access to most of
        the filesystem outside of its data and log directories. By
        adding paths to this list, the set of writeable paths will be
        expanded. This is useful for allowing e.g. backups to local files,
        which must be performed on behalf of the foundationdb service.
      '';
    };

    pidfile = lib.mkOption {
      type = lib.types.path;
      default = "/run/foundationdb.pid";
      description = "Path to pidfile for fdbmonitor.";
    };

    traceFormat = lib.mkOption {
      type = lib.types.enum [
        "xml"
        "json"
      ];
      default = "xml";
      description = "Trace logging format.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.versionOlder cfg.package.version "6.1" -> cfg.traceFormat == "xml";
        message = ''
          Versions of FoundationDB before 6.1 do not support configurable trace formats (only XML is supported).
          This option has no effect for version ''
        + cfg.package.version
        + ''
          , and enabling it is an error.
        '';
      }
    ];

    environment.systemPackages = [ pkg ];

    users.users = lib.optionalAttrs (cfg.user == "foundationdb") {
      foundationdb = {
        description = "FoundationDB User";
        uid = config.ids.uids.foundationdb;
        group = cfg.group;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "foundationdb") {
      foundationdb.gid = config.ids.gids.foundationdb;
    };

    networking.firewall.allowedTCPPortRanges = lib.mkIf cfg.openFirewall [
      {
        from = cfg.listenPortStart;
        to = (cfg.listenPortStart + cfg.serverProcesses) - 1;
      }
    ];

    systemd.tmpfiles.rules = [
      "d /etc/foundationdb 0755 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.dataDir}' 0770 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.logDir}' 0770 ${cfg.user} ${cfg.group} - -"
      "F '${cfg.pidfile}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.foundationdb = {
      description = "FoundationDB Service";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        RequiresMountsFor = "${cfg.dataDir} ${cfg.logDir}";
      };

      serviceConfig =
        let
          rwpaths = [
            cfg.dataDir
            cfg.logDir
            cfg.pidfile
            "/etc/foundationdb"
          ]
          ++ cfg.extraReadWritePaths;
        in
        {
          Type = "simple";
          Restart = "always";
          RestartSec = 5;
          User = cfg.user;
          Group = cfg.group;
          PIDFile = "${cfg.pidfile}";

          PermissionsStartOnly = true; # setup needs root perms
          TimeoutSec = 120; # give reasonable time to shut down

          # Security options
          NoNewPrivileges = true;
          ProtectHome = true;
          ProtectSystem = "strict";
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ReadWritePaths = lib.concatStringsSep " " (map (x: "-" + x) rwpaths);
        };

      path = [
        pkg
        pkgs.coreutils
      ];

      preStart = ''
        if [ ! -f /etc/foundationdb/fdb.cluster ]; then
            cf=/etc/foundationdb/fdb.cluster
            desc=$(tr -dc A-Za-z0-9 </dev/urandom 2>/dev/null | head -c8)
            rand=$(tr -dc A-Za-z0-9 </dev/urandom 2>/dev/null | head -c8)
            echo ''${desc}:''${rand}@${initialIpAddr}:${builtins.toString cfg.listenPortStart} > $cf
            chmod 0664 $cf
            touch "${cfg.dataDir}/.first_startup"
        fi
      '';

      script = "exec fdbmonitor --lockfile ${cfg.pidfile} --conffile ${configFile}";

      postStart = ''
        if [ -e "${cfg.dataDir}/.first_startup" ]; then
          fdbcli --exec "configure new single ssd"
          rm -f "${cfg.dataDir}/.first_startup";
        fi
      '';
    };
  };

  meta.doc = ./foundationdb.md;
  meta.maintainers = with lib.maintainers; [ thoughtpolice ];
}
