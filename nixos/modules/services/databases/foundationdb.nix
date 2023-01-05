{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.foundationdb;
  pkg = cfg.package;

  # used for initial cluster configuration
  initialIpAddr = if (cfg.publicAddress != "auto") then cfg.publicAddress else "127.0.0.1";

  fdbServers = n:
    concatStringsSep "\n" (map (x: "[fdbserver.${toString (x+cfg.listenPortStart)}]") (range 0 (n - 1)));

  backupAgents = n:
    concatStringsSep "\n" (map (x: "[backup_agent.${toString x}]") (range 1 n));

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
    ${optionalString (cfg.class != null) "class = ${cfg.class}"}
    memory         = ${cfg.memory}
    storage_memory = ${cfg.storageMemory}

    ${optionalString (lib.versionAtLeast cfg.package.version "6.1") ''
    trace_format   = ${cfg.traceFormat}
    ''}

    ${optionalString (cfg.tls != null) ''
      tls_plugin           = ${pkg}/libexec/plugins/FDBLibTLS.so
      tls_certificate_file = ${cfg.tls.certificate}
      tls_key_file         = ${cfg.tls.key}
      tls_verify_peers     = ${cfg.tls.allowedPeers}
    ''}

    ${optionalString (cfg.locality.machineId    != null) "locality_machineid=${cfg.locality.machineId}"}
    ${optionalString (cfg.locality.zoneId       != null) "locality_zoneid=${cfg.locality.zoneId}"}
    ${optionalString (cfg.locality.datacenterId != null) "locality_dcid=${cfg.locality.datacenterId}"}
    ${optionalString (cfg.locality.dataHall     != null) "locality_data_hall=${cfg.locality.dataHall}"}

    ${fdbServers cfg.serverProcesses}

    [backup_agent]
    command = ${pkg}/libexec/backup_agent
    ${backupAgents cfg.backupProcesses}
  '';
in
{
  options.services.foundationdb = {

    enable = mkEnableOption (lib.mdDoc "FoundationDB Server");

    package = mkOption {
      type        = types.package;
      description = lib.mdDoc ''
        The FoundationDB package to use for this server. This must be specified by the user
        in order to ensure migrations and upgrades are controlled appropriately.
      '';
    };

    publicAddress = mkOption {
      type        = types.str;
      default     = "auto";
      description = lib.mdDoc "Publicly visible IP address of the process. Port is determined by process ID";
    };

    listenAddress = mkOption {
      type        = types.str;
      default     = "public";
      description = lib.mdDoc "Publicly visible IP address of the process. Port is determined by process ID";
    };

    listenPortStart = mkOption {
      type          = types.int;
      default       = 4500;
      description   = lib.mdDoc ''
        Starting port number for database listening sockets. Every FDB process binds to a
        subsequent port, to this number reflects the start of the overall range. e.g. having
        8 server processes will use all ports between 4500 and 4507.
      '';
    };

    openFirewall = mkOption {
      type        = types.bool;
      default     = false;
      description = lib.mdDoc ''
        Open the firewall ports corresponding to FoundationDB processes and coordinators
        using {option}`config.networking.firewall.*`.
      '';
    };

    dataDir = mkOption {
      type        = types.path;
      default     = "/var/lib/foundationdb";
      description = lib.mdDoc "Data directory. All cluster data will be put under here.";
    };

    logDir = mkOption {
      type        = types.path;
      default     = "/var/log/foundationdb";
      description = lib.mdDoc "Log directory.";
    };

    user = mkOption {
      type        = types.str;
      default     = "foundationdb";
      description = lib.mdDoc "User account under which FoundationDB runs.";
    };

    group = mkOption {
      type        = types.str;
      default     = "foundationdb";
      description = lib.mdDoc "Group account under which FoundationDB runs.";
    };

    class = mkOption {
      type        = types.nullOr (types.enum [ "storage" "transaction" "stateless" ]);
      default     = null;
      description = lib.mdDoc "Process class";
    };

    restartDelay = mkOption {
      type = types.int;
      default = 10;
      description = lib.mdDoc "Number of seconds to wait before restarting servers.";
    };

    logSize = mkOption {
      type        = types.str;
      default     = "10MiB";
      description = lib.mdDoc ''
        Roll over to a new log file after the current log file
        reaches the specified size.
      '';
    };

    maxLogSize = mkOption {
      type        = types.str;
      default     = "100MiB";
      description = lib.mdDoc ''
        Delete the oldest log file when the total size of all log
        files exceeds the specified size. If set to 0, old log files
        will not be deleted.
      '';
    };

    serverProcesses = mkOption {
      type = types.int;
      default = 1;
      description = lib.mdDoc "Number of fdbserver processes to run.";
    };

    backupProcesses = mkOption {
      type = types.int;
      default = 1;
      description = lib.mdDoc "Number of backup_agent processes to run for snapshots.";
    };

    memory = mkOption {
      type        = types.str;
      default     = "8GiB";
      description = lib.mdDoc ''
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

    storageMemory = mkOption {
      type        = types.str;
      default     = "1GiB";
      description = lib.mdDoc ''
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

    tls = mkOption {
      default = null;
      description = lib.mdDoc ''
        FoundationDB Transport Security Layer (TLS) settings.
      '';

      type = types.nullOr (types.submodule ({
        options = {
          certificate = mkOption {
            type = types.str;
            description = lib.mdDoc ''
              Path to the TLS certificate file. This certificate will
              be offered to, and may be verified by, clients.
            '';
          };

          key = mkOption {
            type = types.str;
            description = lib.mdDoc "Private key file for the certificate.";
          };

          allowedPeers = mkOption {
            type = types.str;
            default = "Check.Valid=1,Check.Unexpired=1";
            description = lib.mdDoc ''
              "Peer verification string". This may be used to adjust which TLS
              client certificates a server will accept, as a form of user
              authorization; for example, it may only accept TLS clients who
              offer a certificate abiding by some locality or organization name.

              For more information, please see the FoundationDB documentation.
            '';
          };
        };
      }));
    };

    locality = mkOption {
      default = {
        machineId    = null;
        zoneId       = null;
        datacenterId = null;
        dataHall     = null;
      };

      description = lib.mdDoc ''
        FoundationDB locality settings.
      '';

      type = types.submodule ({
        options = {
          machineId = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = lib.mdDoc ''
              Machine identifier key. All processes on a machine should share a
              unique id. By default, processes on a machine determine a unique id to share.
              This does not generally need to be set.
            '';
          };

          zoneId = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = lib.mdDoc ''
              Zone identifier key. Processes that share a zone id are
              considered non-unique for the purposes of data replication.
              If unset, defaults to machine id.
            '';
          };

          datacenterId = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = lib.mdDoc ''
              Data center identifier key. All processes physically located in a
              data center should share the id. If you are depending on data
              center based replication this must be set on all processes.
            '';
          };

          dataHall = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = lib.mdDoc ''
              Data hall identifier key. All processes physically located in a
              data hall should share the id. If you are depending on data
              hall based replication this must be set on all processes.
            '';
          };
        };
      });
    };

    extraReadWritePaths = mkOption {
      default = [ ];
      type = types.listOf types.path;
      description = lib.mdDoc ''
        An extra set of filesystem paths that FoundationDB can read to
        and write from. By default, FoundationDB runs under a heavily
        namespaced systemd environment without write access to most of
        the filesystem outside of its data and log directories. By
        adding paths to this list, the set of writeable paths will be
        expanded. This is useful for allowing e.g. backups to local files,
        which must be performed on behalf of the foundationdb service.
      '';
    };

    pidfile = mkOption {
      type        = types.path;
      default     = "/run/foundationdb.pid";
      description = lib.mdDoc "Path to pidfile for fdbmonitor.";
    };

    traceFormat = mkOption {
      type = types.enum [ "xml" "json" ];
      default = "xml";
      description = lib.mdDoc "Trace logging format.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = lib.versionOlder cfg.package.version "6.1" -> cfg.traceFormat == "xml";
        message = ''
          Versions of FoundationDB before 6.1 do not support configurable trace formats (only XML is supported).
          This option has no effect for version '' + cfg.package.version + '', and enabling it is an error.
        '';
      }
    ];

    environment.systemPackages = [ pkg ];

    users.users = optionalAttrs (cfg.user == "foundationdb") {
      foundationdb = {
        description = "FoundationDB User";
        uid         = config.ids.uids.foundationdb;
        group       = cfg.group;
      };
    };

    users.groups = optionalAttrs (cfg.group == "foundationdb") {
      foundationdb.gid = config.ids.gids.foundationdb;
    };

    networking.firewall.allowedTCPPortRanges = mkIf cfg.openFirewall
      [ { from = cfg.listenPortStart;
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
      description             = "FoundationDB Service";

      after                   = [ "network.target" ];
      wantedBy                = [ "multi-user.target" ];
      unitConfig =
        { RequiresMountsFor = "${cfg.dataDir} ${cfg.logDir}";
        };

      serviceConfig =
        let rwpaths = [ cfg.dataDir cfg.logDir cfg.pidfile "/etc/foundationdb" ]
                   ++ cfg.extraReadWritePaths;
        in
        { Type       = "simple";
          Restart    = "always";
          RestartSec = 5;
          User       = cfg.user;
          Group      = cfg.group;
          PIDFile    = "${cfg.pidfile}";

          PermissionsStartOnly = true;  # setup needs root perms
          TimeoutSec           = 120;   # give reasonable time to shut down

          # Security options
          NoNewPrivileges       = true;
          ProtectHome           = true;
          ProtectSystem         = "strict";
          ProtectKernelTunables = true;
          ProtectControlGroups  = true;
          PrivateTmp            = true;
          PrivateDevices        = true;
          ReadWritePaths        = lib.concatStringsSep " " (map (x: "-" + x) rwpaths);
        };

      path = [ pkg pkgs.coreutils ];

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

  # Don't edit the docbook xml directly, edit the md and generate it using md-to-db.sh
  meta.doc         = ./foundationdb.xml;
  meta.maintainers = with lib.maintainers; [ thoughtpolice ];
}
