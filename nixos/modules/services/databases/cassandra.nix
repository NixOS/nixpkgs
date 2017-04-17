{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cassandra;
  cassandraPackage = cfg.package.override {
    jre = cfg.jre;
  };
  cassandraUser = {
    name = cfg.user;
    home = "/var/lib/cassandra";
    description = "Cassandra role user";
  };

  cassandraRackDcProperties = ''
    dc=${cfg.dc}
    rack=${cfg.rack}
  '';

  cassandraConf = ''
    cluster_name: ${cfg.clusterName}
    num_tokens: 256
    auto_bootstrap: ${boolToString cfg.autoBootstrap}
    hinted_handoff_enabled: ${boolToString cfg.hintedHandOff}
    hinted_handoff_throttle_in_kb: ${builtins.toString cfg.hintedHandOffThrottle}
    max_hints_delivery_threads: 2
    max_hint_window_in_ms: 10800000 # 3 hours
    authenticator: ${cfg.authenticator}
    authorizer: ${cfg.authorizer}
    permissions_validity_in_ms: 2000
    partitioner: org.apache.cassandra.dht.Murmur3Partitioner
    data_file_directories:
    ${builtins.concatStringsSep "\n" (map (v: "  - "+v) cfg.dataDirs)}
    commitlog_directory: ${cfg.commitLogDirectory}
    disk_failure_policy: stop
    key_cache_size_in_mb:
    key_cache_save_period: 14400
    row_cache_size_in_mb: 0
    row_cache_save_period: 0
    saved_caches_directory: ${cfg.savedCachesDirectory}
    commitlog_sync: ${cfg.commitLogSync}
    commitlog_sync_period_in_ms: ${builtins.toString cfg.commitLogSyncPeriod}
    commitlog_segment_size_in_mb: 32
    seed_provider:
      - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        parameters:
          - seeds: "${builtins.concatStringsSep "," cfg.seeds}"
    concurrent_reads: ${builtins.toString cfg.concurrentReads}
    concurrent_writes: ${builtins.toString cfg.concurrentWrites}
    memtable_flush_queue_size: 4
    trickle_fsync: false
    trickle_fsync_interval_in_kb: 10240
    storage_port: 7000
    ssl_storage_port: 7001
    listen_address: ${cfg.listenAddress}
    start_native_transport: true
    native_transport_port: 9042
    start_rpc: true
    rpc_address: ${cfg.rpcAddress}
    rpc_port: 9160
    rpc_keepalive: true
    rpc_server_type: sync
    thrift_framed_transport_size_in_mb: 15
    incremental_backups: ${boolToString cfg.incrementalBackups}
    snapshot_before_compaction: false
    auto_snapshot: true
    column_index_size_in_kb: 64
    in_memory_compaction_limit_in_mb: 64
    multithreaded_compaction: false
    compaction_throughput_mb_per_sec: 16
    compaction_preheat_key_cache: true
    read_request_timeout_in_ms: 10000
    range_request_timeout_in_ms: 10000
    write_request_timeout_in_ms: 10000
    cas_contention_timeout_in_ms: 1000
    truncate_request_timeout_in_ms: 60000
    request_timeout_in_ms: 10000
    cross_node_timeout: false
    endpoint_snitch: ${cfg.snitch}
    dynamic_snitch_update_interval_in_ms: 100
    dynamic_snitch_reset_interval_in_ms: 600000
    dynamic_snitch_badness_threshold: 0.1
    request_scheduler: org.apache.cassandra.scheduler.NoScheduler
    server_encryption_options:
      internode_encryption: ${cfg.internodeEncryption}
      keystore: ${cfg.keyStorePath}
      keystore_password: ${cfg.keyStorePassword}
      truststore: ${cfg.trustStorePath}
      truststore_password: ${cfg.trustStorePassword}
    client_encryption_options:
      enabled: ${boolToString cfg.clientEncryption}
      keystore: ${cfg.keyStorePath}
      keystore_password: ${cfg.keyStorePassword}
    internode_compression: all
    inter_dc_tcp_nodelay: false
    preheat_kernel_page_cache: false
    streaming_socket_timeout_in_ms: ${toString cfg.streamingSocketTimoutInMS}
  '';

  cassandraLog = ''
    log4j.rootLogger=${cfg.logLevel},stdout
    log4j.appender.stdout=org.apache.log4j.ConsoleAppender
    log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
    log4j.appender.stdout.layout.ConversionPattern=%5p [%t] %d{HH:mm:ss,SSS} %m%n
  '';

  cassandraConfFile = pkgs.writeText "cassandra.yaml" cassandraConf;
  cassandraLogFile = pkgs.writeText "log4j-server.properties" cassandraLog;
  cassandraRackFile = pkgs.writeText "cassandra-rackdc.properties" cassandraRackDcProperties;

  cassandraEnvironment = {
    CASSANDRA_HOME = cassandraPackage;
    JAVA_HOME = cfg.jre;
    CASSANDRA_CONF = "/etc/cassandra";
  };

in {

  ###### interface

  options.services.cassandra = {
    enable = mkOption {
      description = "Whether to enable cassandra.";
      default = false;
      type = types.bool;
    };
    package = mkOption {
      description = "Cassandra package to use.";
      default = pkgs.cassandra;
      defaultText = "pkgs.cassandra";
      type = types.package;
    };
    jre = mkOption {
      description = "JRE package to run cassandra service.";
      default = pkgs.jre;
      defaultText = "pkgs.jre";
      type = types.package;
    };
    user = mkOption {
      description = "User that runs cassandra service.";
      default = "cassandra";
      type = types.string;
    };
    group = mkOption {
      description = "Group that runs cassandra service.";
      default = "cassandra";
      type = types.string;
    };
    envFile = mkOption {
      description = "path to cassandra-env.sh";
      default = "${cassandraPackage}/conf/cassandra-env.sh";
      defaultText = "\${cassandraPackage}/conf/cassandra-env.sh";
      type = types.path;
    };
    clusterName = mkOption {
      description = "set cluster name";
      default = "cassandra";
      example = "prod-cluster0";
      type = types.string;
    };
    commitLogDirectory = mkOption {
      description = "directory for commit logs";
      default = "/var/lib/cassandra/commit_log";
      type = types.string;
    };
    savedCachesDirectory = mkOption {
      description = "directory for saved caches";
      default = "/var/lib/cassandra/saved_caches";
      type = types.string;
    };
    hintedHandOff = mkOption {
      description = "enable hinted handoff";
      default = true;
      type = types.bool;
    };
    hintedHandOffThrottle = mkOption {
      description = "hinted hand off throttle rate in kb";
      default = 1024;
      type = types.int;
    };
    commitLogSync = mkOption {
      description = "commitlog sync method";
      default = "periodic";
      type = types.str;
      example = "batch";
    };
    commitLogSyncPeriod = mkOption {
      description = "commitlog sync period in ms ";
      default = 10000;
      type = types.int;
    };
    envScript = mkOption {
      default = "${cassandraPackage}/conf/cassandra-env.sh";
      defaultText = "\${cassandraPackage}/conf/cassandra-env.sh";
      type = types.path;
      description = "Supply your own cassandra-env.sh rather than using the default";
    };
    extraParams = mkOption {
      description = "add additional lines to cassandra-env.sh";
      default = [];
      example = [''JVM_OPTS="$JVM_OPTS -Dcassandra.available_processors=1"''];
      type = types.listOf types.str;
    };
    dataDirs = mkOption {
      type = types.listOf types.path;
      default = [ "/var/lib/cassandra/data" ];
      description = "Data directories for cassandra";
    };
    logLevel = mkOption {
      type = types.str;
      default = "INFO";
      description = "default logging level for log4j";
    };
    internodeEncryption = mkOption {
      description = "enable internode encryption";
      default = "none";
      example = "all";
      type = types.str;
    };
    clientEncryption = mkOption {
      description = "enable client encryption";
      default = false;
      type = types.bool;
    };
    trustStorePath = mkOption {
      description = "path to truststore";
      default = ".conf/truststore";
      type = types.str;
    };
    keyStorePath = mkOption {
      description = "path to keystore";
      default = ".conf/keystore";
      type = types.str;
    };
    keyStorePassword = mkOption {
      description = "password to keystore";
      default = "cassandra";
      type = types.str;
    };
    trustStorePassword = mkOption {
      description = "password to truststore";
      default = "cassandra";
      type = types.str;
    };
    seeds = mkOption {
      description = "password to truststore";
      default = [ "127.0.0.1" ];
      type = types.listOf types.str;
    };
    concurrentWrites = mkOption {
      description = "number of concurrent writes allowed";
      default = 32;
      type = types.int;
    };
    concurrentReads = mkOption {
      description = "number of concurrent reads allowed";
      default = 32;
      type = types.int;
    };
    listenAddress = mkOption {
      description = "listen address";
      default = "localhost";
      type = types.str;
    };
    rpcAddress = mkOption {
      description = "rpc listener address";
      default = "localhost";
      type = types.str;
    };
    incrementalBackups = mkOption {
      description = "enable incremental backups";
      default = false;
      type = types.bool;
    };
    snitch = mkOption {
      description = "snitch to use for topology discovery";
      default = "GossipingPropertyFileSnitch";
      example = "Ec2Snitch";
      type = types.str;
    };
    dc = mkOption {
      description = "datacenter for use in topology configuration";
      default = "DC1";
      example = "DC1";
      type = types.str;
    };
    rack = mkOption {
      description = "rack for use in topology configuration";
      default = "RAC1";
      example = "RAC1";
      type = types.str;
    };
    authorizer = mkOption {
      description = "
        Authorization backend, implementing IAuthorizer; used to limit access/provide permissions
      ";
      default = "AllowAllAuthorizer";
      example = "CassandraAuthorizer";
      type = types.str;
    };
    authenticator = mkOption {
      description = "
        Authentication backend, implementing IAuthenticator; used to identify users
      ";
      default = "AllowAllAuthenticator";
      example = "PasswordAuthenticator";
      type = types.str;
    };
    autoBootstrap = mkOption {
      description = "It makes new (non-seed) nodes automatically migrate the right data to themselves.";
      default = true;
      type = types.bool;
    };
    streamingSocketTimoutInMS = mkOption {
      description = "Enable or disable socket timeout for streaming operations";
      default = 3600000; #CASSANDRA-8611
      example = 120;
      type = types.int;
    };
    repairStartAt = mkOption {
      default = "Sun";
      type = types.string;
      description = ''
      Defines realtime (i.e. wallclock) timers with calendar event
      expressions. For more details re: systemd OnCalendar at
      https://www.freedesktop.org/software/systemd/man/systemd.time.html#Displaying%20Time%20Spans
      '';
      example = ["weekly" "daily" "08:05:40" "mon,fri *-1/2-1,3 *:30:45"];
    };
    repairRandomizedDelayInSec = mkOption {
      default = 0;
      type = types.int;
      description = ''Delay the timer by a randomly selected, evenly distributed
      amount of time between 0 and the specified time value. re: systemd timer
      RandomizedDelaySec for more details
      '';
    };
    repairPostStop = mkOption {
      default = null;
      type = types.nullOr types.string;
      description = ''
      Run a script when repair is over. One can use it to send statsd events, email, etc.
      '';
    };
    repairPostStart = mkOption {
      default = null;
      type = types.nullOr types.string;
      description = ''
      Run a script when repair starts. One can use it to send statsd events, email, etc.
      It has same semantics as systemd ExecStopPost; So, if it fails, unit is consisdered
      failed.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.etc."cassandra/cassandra-rackdc.properties" = {
      source = cassandraRackFile;
    };
    environment.etc."cassandra/cassandra.yaml" = {
      source = cassandraConfFile;
    };
    environment.etc."cassandra/log4j-server.properties" = {
      source = cassandraLogFile;
    };
    environment.etc."cassandra/cassandra-env.sh" = {
      text = ''
        ${builtins.readFile cfg.envFile}
        ${concatStringsSep "\n" cfg.extraParams}
      '';
    };
    systemd.services.cassandra = {
      description = "Cassandra Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = cassandraEnvironment;
      restartTriggers = [ cassandraConfFile cassandraLogFile cassandraRackFile ];
      serviceConfig = {

        User = cfg.user;
        PermissionsStartOnly = true;
        LimitAS = "infinity";
        LimitNOFILE = "100000";
        LimitNPROC = "32768";
        LimitMEMLOCK = "infinity";

      };
      script = ''
         ${cassandraPackage}/bin/cassandra -f
        '';
      path = [
        cfg.jre
        cassandraPackage
        pkgs.coreutils
      ];
      preStart = ''
        mkdir -m 0700 -p /etc/cassandra/triggers
        mkdir -m 0700 -p /var/lib/cassandra /var/log/cassandra
        chown ${cfg.user} /var/lib/cassandra /var/log/cassandra /etc/cassandra/triggers
      '';
      postStart = ''
        sleep 2
        while ! nodetool status >/dev/null 2>&1; do
          sleep 2
        done
        nodetool status
      '';
    };

    environment.systemPackages = [ cassandraPackage ];

    networking.firewall.allowedTCPPorts = [
      7000
      7001
      9042
      9160
    ];

    users.extraUsers.cassandra =
      if config.ids.uids ? "cassandra"
      then { uid = config.ids.uids.cassandra; } // cassandraUser
      else cassandraUser ;

    boot.kernel.sysctl."vm.swappiness" = pkgs.lib.mkOptionDefault 0;

    systemd.timers."cassandra-repair" = {
      timerConfig = {
        OnCalendar = "${toString cfg.repairStartAt}";
        RandomizedDelaySec = cfg.repairRandomizedDelayInSec;
      };
    };

    systemd.services."cassandra-repair" = {
      description = "Cassandra repair daemon";
      environment = cassandraEnvironment;
      script = "${cassandraPackage}/bin/nodetool repair -pr";
      postStop = mkIf (cfg.repairPostStop != null) cfg.repairPostStop;
      postStart = mkIf (cfg.repairPostStart != null) cfg.repairPostStart;
      serviceConfig = {
        User = cfg.user;
      };
    };
  };
}
