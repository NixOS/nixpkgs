{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    flip
    literalMD
    literalExpression
    optionalAttrs
    optionals
    recursiveUpdate
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    versionAtLeast
    ;

  cfg = config.services.cassandra;

  atLeast3 = versionAtLeast cfg.package.version "3";
  atLeast3_11 = versionAtLeast cfg.package.version "3.11";
  atLeast4 = versionAtLeast cfg.package.version "4";

  defaultUser = "cassandra";

  cassandraConfig = flip recursiveUpdate cfg.extraConfig (
    {
      commitlog_sync = "batch";
      commitlog_sync_batch_window_in_ms = 2;
      start_native_transport = cfg.allowClients;
      cluster_name = cfg.clusterName;
      partitioner = "org.apache.cassandra.dht.Murmur3Partitioner";
      endpoint_snitch = "SimpleSnitch";
      data_file_directories = [ "${cfg.homeDir}/data" ];
      commitlog_directory = "${cfg.homeDir}/commitlog";
      saved_caches_directory = "${cfg.homeDir}/saved_caches";
    }
    // optionalAttrs (cfg.seedAddresses != [ ]) {
      seed_provider = [
        {
          class_name = "org.apache.cassandra.locator.SimpleSeedProvider";
          parameters = [ { seeds = concatStringsSep "," cfg.seedAddresses; } ];
        }
      ];
    }
    // optionalAttrs atLeast3 {
      hints_directory = "${cfg.homeDir}/hints";
    }
  );

  cassandraConfigWithAddresses =
    cassandraConfig
    // (
      if cfg.listenAddress == null then
        { listen_interface = cfg.listenInterface; }
      else
        { listen_address = cfg.listenAddress; }
    )
    // (
      if cfg.rpcAddress == null then
        { rpc_interface = cfg.rpcInterface; }
      else
        { rpc_address = cfg.rpcAddress; }
    );

  cassandraEtc = pkgs.stdenv.mkDerivation {
    name = "cassandra-etc";

    cassandraYaml = builtins.toJSON cassandraConfigWithAddresses;
    cassandraEnvPkg = "${cfg.package}/conf/cassandra-env.sh";
    cassandraLogbackConfig = pkgs.writeText "logback.xml" cfg.logbackConfig;

    passAsFile = [ "extraEnvSh" ];
    inherit (cfg) extraEnvSh package;

    buildCommand = ''
      mkdir -p "$out"

      echo "$cassandraYaml" > "$out/cassandra.yaml"
      ln -s "$cassandraLogbackConfig" "$out/logback.xml"

      ( cat "$cassandraEnvPkg"
        echo "# lines from services.cassandra.extraEnvSh: "
        cat "$extraEnvShPath"
      ) > "$out/cassandra-env.sh"

      # Delete default JMX Port, otherwise we can't set it using env variable
      sed -i '/JMX_PORT="7199"/d' "$out/cassandra-env.sh"

      # Delete default password file
      sed -i '/-Dcom.sun.management.jmxremote.password.file=\/etc\/cassandra\/jmxremote.password/d' "$out/cassandra-env.sh"

      ${lib.optionalString atLeast4 ''
        cp $package/conf/jvm*.options $out/
      ''}
    '';
  };

  defaultJmxRolesFile = builtins.foldl' (left: right: left + right) "" (
    map (role: "${role.username} ${role.password}") cfg.jmxRoles
  );

  fullJvmOptions =
    cfg.jvmOpts
    ++ optionals (cfg.jmxRoles != [ ]) [
      "-Dcom.sun.management.jmxremote.authenticate=true"
      "-Dcom.sun.management.jmxremote.password.file=${cfg.jmxRolesFile}"
    ]
    ++ optionals cfg.remoteJmx [
      "-Djava.rmi.server.hostname=${cfg.rpcAddress}"
    ]
    ++ optionals atLeast4 [
      # Historically, we don't use a log dir, whereas the upstream scripts do
      # expect this. We override those by providing our own -Xlog:gc flag.
      "-Xlog:gc=warning,heap*=warning,age*=warning,safepoint=warning,promotion*=warning"
    ];

  commonEnv = {
    # Sufficient for cassandra 2.x, 3.x
    CASSANDRA_CONF = "${cassandraEtc}";

    # Required since cassandra 4
    CASSANDRA_LOGBACK_CONF = "${cassandraEtc}/logback.xml";
  };

in
{
  options.services.cassandra = {

    enable = mkEnableOption ''
      Apache Cassandra – Scalable and highly available database
    '';

    clusterName = mkOption {
      type = types.str;
      default = "Test Cluster";
      description = ''
        The name of the cluster.
        This setting prevents nodes in one logical cluster from joining
        another. All nodes in a cluster must have the same value.
      '';
    };

    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = "Run Apache Cassandra under this user.";
    };

    group = mkOption {
      type = types.str;
      default = defaultUser;
      description = "Run Apache Cassandra under this group.";
    };

    homeDir = mkOption {
      type = types.path;
      default = "/var/lib/cassandra";
      description = ''
        Home directory for Apache Cassandra.
      '';
    };

    package = mkPackageOption pkgs "cassandra" {
      example = "cassandra_3_11";
    };

    jvmOpts = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Populate the `JVM_OPT` environment variable.
      '';
    };

    listenAddress = mkOption {
      type = types.nullOr types.str;
      default = "127.0.0.1";
      example = null;
      description = ''
        Address or interface to bind to and tell other Cassandra nodes
        to connect to. You _must_ change this if you want multiple
        nodes to be able to communicate!

        Set {option}`listenAddress` OR {option}`listenInterface`, not both.

        Leaving it blank leaves it up to
        `InetAddress.getLocalHost()`. This will always do the "Right
        Thing" _if_ the node is properly configured (hostname, name
        resolution, etc), and the Right Thing is to use the address
        associated with the hostname (it might not be).

        Setting {option}`listenAddress` to `0.0.0.0` is always wrong.
      '';
    };

    listenInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "eth1";
      description = ''
        Set `listenAddress` OR `listenInterface`, not both. Interfaces
        must correspond to a single address, IP aliasing is not
        supported.
      '';
    };

    rpcAddress = mkOption {
      type = types.nullOr types.str;
      default = "127.0.0.1";
      example = null;
      description = ''
        The address or interface to bind the native transport server to.

        Set {option}`rpcAddress` OR {option}`rpcInterface`, not both.

        Leaving {option}`rpcAddress` blank has the same effect as on
        {option}`listenAddress` (i.e. it will be based on the configured hostname
        of the node).

        Note that unlike {option}`listenAddress`, you can specify `"0.0.0.0"`, but you
        must also set `extraConfig.broadcast_rpc_address` to a value other
        than `"0.0.0.0"`.

        For security reasons, you should not expose this port to the
        internet. Firewall it if needed.
      '';
    };

    rpcInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "eth1";
      description = ''
        Set {option}`rpcAddress` OR {option}`rpcInterface`, not both. Interfaces must
        correspond to a single address, IP aliasing is not supported.
      '';
    };

    logbackConfig = mkOption {
      type = types.lines;
      default = ''
        <configuration scan="false">
          <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
              <pattern>%-5level %date{HH:mm:ss,SSS} %msg%n</pattern>
            </encoder>
          </appender>

          <root level="INFO">
            <appender-ref ref="STDOUT" />
          </root>

          <logger name="com.thinkaurelius.thrift" level="ERROR"/>
        </configuration>
      '';
      description = ''
        XML logback configuration for cassandra
      '';
    };

    seedAddresses = mkOption {
      type = types.listOf types.str;
      default = [ "127.0.0.1" ];
      description = ''
        The addresses of hosts designated as contact points in the cluster. A
        joining node contacts one of the nodes in the seeds list to learn the
        topology of the ring.
        Set to `[ "127.0.0.1" ]` for a single node cluster.
      '';
    };

    allowClients = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enables or disables the native transport server (CQL binary protocol).
        This server uses the same address as the {option}`rpcAddress`,
        but the port it uses is not `rpc_port` but
        `native_transport_port`. See the official Cassandra
        docs for more information on these variables and set them using
        {option}`extraConfig`.
      '';
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = { };
      example = {
        commitlog_sync_batch_window_in_ms = 3;
      };
      description = ''
        Extra options to be merged into {file}`cassandra.yaml` as nix attribute set.
      '';
    };

    extraEnvSh = mkOption {
      type = types.lines;
      default = "";
      example = literalExpression ''"CLASSPATH=$CLASSPATH:''${extraJar}"'';
      description = ''
        Extra shell lines to be appended onto {file}`cassandra-env.sh`.
      '';
    };

    fullRepairInterval = mkOption {
      type = types.nullOr types.str;
      default = "3w";
      example = null;
      description = ''
        Set the interval how often full repairs are run, i.e.
        {command}`nodetool repair --full` is executed. See
        <https://cassandra.apache.org/doc/latest/operating/repair.html>
        for more information.

        Set to `null` to disable full repairs.
      '';
    };

    fullRepairOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--partitioner-range" ];
      description = ''
        Options passed through to the full repair command.
      '';
    };

    incrementalRepairInterval = mkOption {
      type = types.nullOr types.str;
      default = "3d";
      example = null;
      description = ''
        Set the interval how often incremental repairs are run, i.e.
        {command}`nodetool repair` is executed. See
        <https://cassandra.apache.org/doc/latest/operating/repair.html>
        for more information.

        Set to `null` to disable incremental repairs.
      '';
    };

    incrementalRepairOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--partitioner-range" ];
      description = ''
        Options passed through to the incremental repair command.
      '';
    };

    maxHeapSize = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "4G";
      description = ''
        Must be left blank or set together with {option}`heapNewSize`.
        If left blank a sensible value for the available amount of RAM and CPU
        cores is calculated.

        Override to set the amount of memory to allocate to the JVM at
        start-up. For production use you may wish to adjust this for your
        environment. `MAX_HEAP_SIZE` is the total amount of memory dedicated
        to the Java heap. `HEAP_NEWSIZE` refers to the size of the young
        generation.

        The main trade-off for the young generation is that the larger it
        is, the longer GC pause times will be. The shorter it is, the more
        expensive GC will be (usually).
      '';
    };

    heapNewSize = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "800M";
      description = ''
        Must be left blank or set together with {option}`heapNewSize`.
        If left blank a sensible value for the available amount of RAM and CPU
        cores is calculated.

        Override to set the amount of memory to allocate to the JVM at
        start-up. For production use you may wish to adjust this for your
        environment. `HEAP_NEWSIZE` refers to the size of the young
        generation.

        The main trade-off for the young generation is that the larger it
        is, the longer GC pause times will be. The shorter it is, the more
        expensive GC will be (usually).

        The example `HEAP_NEWSIZE` assumes a modern 8-core+ machine for decent pause
        times. If in doubt, and if you do not particularly want to tweak, go with
        100 MB per physical CPU core.
      '';
    };

    mallocArenaMax = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 4;
      description = ''
        Set this to control the amount of arenas per-thread in glibc.
      '';
    };

    remoteJmx = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Cassandra ships with JMX accessible *only* from localhost.
        To enable remote JMX connections set to true.

        Be sure to also enable authentication and/or TLS.
        See: <https://wiki.apache.org/cassandra/JmxSecurity>
      '';
    };

    jmxPort = mkOption {
      type = types.int;
      default = 7199;
      description = ''
        Specifies the default port over which Cassandra will be available for
        JMX connections.
        For security reasons, you should not expose this port to the internet.
        Firewall it if needed.
      '';
    };

    jmxRoles = mkOption {
      default = [ ];
      description = ''
        Roles that are allowed to access the JMX (e.g. {command}`nodetool`)
        BEWARE: The passwords will be stored world readable in the nix store.
                It's recommended to use your own protected file using
                {option}`jmxRolesFile`

        Doesn't work in versions older than 3.11 because they don't like that
        it's world readable.
      '';
      type = types.listOf (
        types.submodule {
          options = {
            username = mkOption {
              type = types.str;
              description = "Username for JMX";
            };
            password = mkOption {
              type = types.str;
              description = "Password for JMX";
            };
          };
        }
      );
    };

    jmxRolesFile = mkOption {
      type = types.nullOr types.path;
      default = if atLeast3_11 then pkgs.writeText "jmx-roles-file" defaultJmxRolesFile else null;
      defaultText = literalMD ''generated configuration file if version is at least 3.11, otherwise `null`'';
      example = "/var/lib/cassandra/jmx.password";
      description = ''
        Specify your own jmx roles file.

        Make sure the permissions forbid "others" from reading the file if
        you're using Cassandra below version 3.11.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.listenAddress == null) != (cfg.listenInterface == null);
        message = "You have to set either listenAddress or listenInterface";
      }
      {
        assertion = (cfg.rpcAddress == null) != (cfg.rpcInterface == null);
        message = "You have to set either rpcAddress or rpcInterface";
      }
      {
        assertion = (cfg.maxHeapSize == null) == (cfg.heapNewSize == null);
        message = "If you set either of maxHeapSize or heapNewSize you have to set both";
      }
      {
        assertion = cfg.remoteJmx -> cfg.jmxRolesFile != null;
        message = ''
          If you want JMX available remotely you need to set a password using
          <literal>jmxRoles</literal> or <literal>jmxRolesFile</literal> if
          using Cassandra older than v3.11.
        '';
      }
    ];
    users = mkIf (cfg.user == defaultUser) {
      users.${defaultUser} = {
        group = cfg.group;
        home = cfg.homeDir;
        createHome = true;
        uid = config.ids.uids.cassandra;
        description = "Cassandra service user";
      };
      groups.${defaultUser}.gid = config.ids.gids.cassandra;
    };

    systemd.services.cassandra = {
      description = "Apache Cassandra service";
      after = [ "network.target" ];
      environment = commonEnv // {
        JVM_OPTS = builtins.concatStringsSep " " fullJvmOptions;
        MAX_HEAP_SIZE = toString cfg.maxHeapSize;
        HEAP_NEWSIZE = toString cfg.heapNewSize;
        MALLOC_ARENA_MAX = toString cfg.mallocArenaMax;
        LOCAL_JMX = if cfg.remoteJmx then "no" else "yes";
        JMX_PORT = toString cfg.jmxPort;
      };
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/cassandra -f";
        SuccessExitStatus = 143;
      };
    };

    systemd.services.cassandra-full-repair = {
      description = "Perform a full repair on this Cassandra node";
      after = [ "cassandra.service" ];
      requires = [ "cassandra.service" ];
      environment = commonEnv;
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = concatStringsSep " " (
          [
            "${cfg.package}/bin/nodetool"
            "repair"
            "--full"
          ]
          ++ cfg.fullRepairOptions
        );
      };
    };

    systemd.timers.cassandra-full-repair = mkIf (cfg.fullRepairInterval != null) {
      description = "Schedule full repairs on Cassandra";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = cfg.fullRepairInterval;
        OnUnitActiveSec = cfg.fullRepairInterval;
        Persistent = true;
      };
    };

    systemd.services.cassandra-incremental-repair = {
      description = "Perform an incremental repair on this cassandra node.";
      after = [ "cassandra.service" ];
      requires = [ "cassandra.service" ];
      environment = commonEnv;
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = concatStringsSep " " (
          [
            "${cfg.package}/bin/nodetool"
            "repair"
          ]
          ++ cfg.incrementalRepairOptions
        );
      };
    };

    systemd.timers.cassandra-incremental-repair = mkIf (cfg.incrementalRepairInterval != null) {
      description = "Schedule incremental repairs on Cassandra";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = cfg.incrementalRepairInterval;
        OnUnitActiveSec = cfg.incrementalRepairInterval;
        Persistent = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ roberth ];
}
