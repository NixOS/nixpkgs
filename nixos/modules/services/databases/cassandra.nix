{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cassandra;
  defaultUser = "cassandra";
  cassandraConfig = flip recursiveUpdate cfg.extraConfig
    ({ commitlog_sync = "batch";
       commitlog_sync_batch_window_in_ms = 2;
       partitioner = "org.apache.cassandra.dht.Murmur3Partitioner";
       endpoint_snitch = "SimpleSnitch";
       seed_provider =
         [{ class_name = "org.apache.cassandra.locator.SimpleSeedProvider";
            parameters = [ { seeds = "127.0.0.1"; } ];
         }];
       data_file_directories = [ "${cfg.homeDir}/data" ];
       commitlog_directory = "${cfg.homeDir}/commitlog";
       saved_caches_directory = "${cfg.homeDir}/saved_caches";
     } // (if builtins.compareVersions cfg.package.version "3" >= 0
             then { hints_directory = "${cfg.homeDir}/hints"; }
             else {})
    );
  cassandraConfigWithAddresses = cassandraConfig //
    ( if isNull cfg.listenAddress
        then { listen_interface = cfg.listenInterface; }
        else { listen_address = cfg.listenAddress; }
    ) // (
      if isNull cfg.rpcAddress
        then { rpc_interface = cfg.rpcInterface; }
        else { rpc_address = cfg.rpcAddress; }
    );
  cassandraEtc = pkgs.stdenv.mkDerivation
    { name = "cassandra-etc";
      cassandraYaml = builtins.toJSON cassandraConfigWithAddresses;
      cassandraEnvPkg = "${cfg.package}/conf/cassandra-env.sh";
      buildCommand = ''
        mkdir -p "$out"

        echo "$cassandraYaml" > "$out/cassandra.yaml"
        ln -s "$cassandraEnvPkg" "$out/cassandra-env.sh"
      '';
    };
in {
  options.services.cassandra = {
    enable = mkEnableOption ''
      Apache Cassandra – Scalable and highly available database.
    '';
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
    package = mkOption {
      type = types.package;
      default = pkgs.cassandra;
      defaultText = "pkgs.cassandra";
      example = literalExample "pkgs.cassandra_3_11";
      description = ''
        The Apache Cassandra package to use.
      '';
    };
    jvmOpts = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Populate the JVM_OPT environment variable.
      '';
    };
    listenAddress = mkOption {
      type = types.nullOr types.str;
      default = "127.0.0.1";
      example = literalExample "null";
      description = ''
        Address or interface to bind to and tell other Cassandra nodes
        to connect to. You _must_ change this if you want multiple
        nodes to be able to communicate!

        Set listenAddress OR listenInterface, not both.

        Leaving it blank leaves it up to
        InetAddress.getLocalHost(). This will always do the Right
        Thing _if_ the node is properly configured (hostname, name
        resolution, etc), and the Right Thing is to use the address
        associated with the hostname (it might not be).

        Setting listen_address to 0.0.0.0 is always wrong.
      '';
    };
    listenInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "eth1";
      description = ''
        Set listenAddress OR listenInterface, not both. Interfaces
        must correspond to a single address, IP aliasing is not
        supported.
      '';
    };
    rpcAddress = mkOption {
      type = types.nullOr types.str;
      default = "127.0.0.1";
      example = literalExample "null";
      description = ''
        The address or interface to bind the native transport server to.

        Set rpcAddress OR rpcInterface, not both.

        Leaving rpcAddress blank has the same effect as on
        listenAddress (i.e. it will be based on the configured hostname
        of the node).

        Note that unlike listenAddress, you can specify 0.0.0.0, but you
        must also set extraConfig.broadcast_rpc_address to a value other
        than 0.0.0.0.

        For security reasons, you should not expose this port to the
        internet. Firewall it if needed.
      '';
    };
    rpcInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "eth1";
      description = ''
        Set rpcAddress OR rpcInterface, not both. Interfaces must
        correspond to a single address, IP aliasing is not supported.
      '';
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      example =
        { commitlog_sync_batch_window_in_ms = 3;
        };
      description = ''
        Extra options to be merged into cassandra.yaml as nix attribute set.
      '';
    };
    fullRepairInterval = mkOption {
      type = types.nullOr types.str;
      default = "3w";
      example = literalExample "null";
      description = ''
          Set the interval how often full repairs are run, i.e.
          `nodetool repair --full` is executed. See
          https://cassandra.apache.org/doc/latest/operating/repair.html
          for more information.

          Set to `null` to disable full repairs.
        '';
    };
    fullRepairOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "--partitioner-range" ];
      description = ''
          Options passed through to the full repair command.
        '';
    };
    incrementalRepairInterval = mkOption {
      type = types.nullOr types.str;
      default = "3d";
      example = literalExample "null";
      description = ''
          Set the interval how often incremental repairs are run, i.e.
          `nodetool repair` is executed. See
          https://cassandra.apache.org/doc/latest/operating/repair.html
          for more information.

          Set to `null` to disable incremental repairs.
        '';
    };
    incrementalRepairOptions = mkOption {
      type = types.listOf types.string;
      default = [];
      example = [ "--partitioner-range" ];
      description = ''
          Options passed through to the incremental repair command.
        '';
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [ { assertion =
            ((isNull cfg.listenAddress)
             || (isNull cfg.listenInterface)
            ) && !((isNull cfg.listenAddress)
                   && (isNull cfg.listenInterface)
                  );
          message = "You have to set either listenAddress or listenInterface";
        }
        { assertion =
            ((isNull cfg.rpcAddress)
             || (isNull cfg.rpcInterface)
            ) && !((isNull cfg.rpcAddress)
                   && (isNull cfg.rpcInterface)
                  );
          message = "You have to set either rpcAddress or rpcInterface";
        }
      ];
    users = mkIf (cfg.user == defaultUser) {
      extraUsers."${defaultUser}" =
        {  group = cfg.group;
           home = cfg.homeDir;
           createHome = true;
           uid = config.ids.uids.cassandra;
           description = "Cassandra service user";
        };
      extraGroups."${defaultUser}".gid = config.ids.gids.cassandra;
    };

    systemd.services.cassandra =
      { description = "Apache Cassandra service";
        after = [ "network.target" ];
        environment =
          { CASSANDRA_CONF = "${cassandraEtc}";
            JVM_OPTS = builtins.concatStringsSep " " cfg.jvmOpts;
          };
        wantedBy = [ "multi-user.target" ];
        serviceConfig =
          { User = cfg.user;
            Group = cfg.group;
            ExecStart = "${cfg.package}/bin/cassandra -f";
            SuccessExitStatus = 143;
          };
      };

    systemd.services.cassandra-full-repair =
      { description = "Perform a full repair on this Cassandra node";
        after = [ "cassandra.service" ];
        requires = [ "cassandra.service" ];
        serviceConfig =
          { User = cfg.user;
            Group = cfg.group;
            ExecStart =
              lib.concatStringsSep " "
                ([ "${cfg.package}/bin/nodetool" "repair" "--full"
                 ] ++ cfg.fullRepairOptions);
          };
      };
    systemd.timers.cassandra-full-repair =
      mkIf (!isNull cfg.fullRepairInterval) {
        description = "Schedule full repairs on Cassandra";
        wantedBy = [ "timers.target" ];
        timerConfig =
          { OnBootSec = cfg.fullRepairInterval;
            OnUnitActiveSec = cfg.fullRepairInterval;
            Persistent = true;
          };
      };

    systemd.services.cassandra-incremental-repair =
      { description = "Perform an incremental repair on this cassandra node.";
        after = [ "cassandra.service" ];
        requires = [ "cassandra.service" ];
        serviceConfig =
          { User = cfg.user;
            Group = cfg.group;
            ExecStart =
              lib.concatStringsSep " "
                ([ "${cfg.package}/bin/nodetool" "repair"
                 ] ++ cfg.incrementalRepairOptions);
          };
      };
    systemd.timers.cassandra-incremental-repair =
      mkIf (!isNull cfg.incrementalRepairInterval) {
        description = "Schedule incremental repairs on Cassandra";
        wantedBy = [ "timers.target" ];
        timerConfig =
          { OnBootSec = cfg.incrementalRepairInterval;
            OnUnitActiveSec = cfg.incrementalRepairInterval;
            Persistent = true;
          };
      };
  };
}
