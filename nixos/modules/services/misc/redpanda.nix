{ config, lib, pkgs, ... }:
with lib;

let
  inherit (builtins) toJSON toFile isList;
  inherit (pkgs) redpanda redpanda-rpk;
  cfg = config.services.redpanda;

  nodeDefault = {
    redpanda = {
      data_directory = "${cfg.configDir}/data";
      rpc_server = { address = "127.0.0.1"; port = 33145; };
      advertised_rpc_api = { address = "0.0.0.0"; port = 33145; };
      kafka_api = [
        { address = "0.0.0.0"; port = 9092; }
      ];
      admin = [
        { address = "127.0.0.1"; port = 9644; }
      ];
      developer_mode = true;
      empty_seed_starts_cluster = false;  # Recommended, but must be true for one-node cluster
    };
    rpk = {
      coredump_dir = "${cfg.configDir}/coredump";
      overprovisioned = true;
    };
    pandaproxy.pandaproxy_api = [
      { address = "0.0.0.0"; port = 8082;}
    ];
    schema_registry.schema_registry_api = [
      { address = "0.0.0.0"; port = 8081;}
    ];
  };

  nodeConfig = lib.attrsets.recursiveUpdate nodeDefault cfg.settings.node;
  nodeYaml = toFile "redpanda.yaml" ( toJSON nodeConfig );

  clusterYaml = toFile "redpanda-cluster.yaml" ( toJSON cfg.settings.cluster );

  # Find all address/port sets in node configuration, for opening dynamically
  hasPort = x: (x ? address) && (x ? port);
  portCfg = lib.attrsets.collect hasPort nodeConfig;  # Specified in sets
  listedPortCfg = lib.lists.flatten (  # Specified in list of sets
    lib.attrsets.collect
      (x: isList x && (lib.lists.all hasPort x))
      nodeConfig
  ); # We do not search down in these attrsets
  portsToOpen = map (x: x.port) (portCfg ++ listedPortCfg);

  runMode = if nodeConfig.redpanda.developer_mode then "dev" else "prod";

in
{
  options.services.redpanda = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = "Toggle this module";
    };

    configDir = mkOption {
      type = str;
      description = "Directory of redpanda config";
      default = "/var/lib/redpanda";
    };

    openPorts = mkOption {
      type = bool;
      description = "Optionally open all relevant ports";
      default = true;
    };

    admin = mkOption {
      description = "Superuser credentials";
      default = null;
      type = nullOr (submodule {
        options = {
          username = mkOption {
            type = str;
            default = "admin";
          };
          password = mkOption {
            type = path;
            description = "Password file";
          };
          saslMechanism = mkOption {
            type = enum ["scram-sha-512" "scram-sha-256"];
            default = "scram-sha-256";
          };
        };
      });
    };

    autoRestart = mkOption {
      type = bool;
      description = ''Restart local redpanda process if cluster config needs it

      This is under development, and probably doesn't work with multiple nodes.
      '';
      default = false;
    };

    settings = mkOption {
      description = "Configuration properties";
      type = submodule {
        options = {
          node = mkOption {
            type = attrsOf anything;
            description = ''Node configuration properties

            Will merge with default configuration, and tuned on startup.
            Reference: https://docs.redpanda.com/docs/reference/node-configuration-sample/
            '';
            default = {};
          };
          cluster = mkOption {
            type = attrsOf anything;
            description = ''Cluster configuration properties

            Reference: https://docs.redpanda.com/docs/reference/cluster-properties/
            '';
            default = {};
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ redpanda-rpk ];
    networking.firewall.allowedTCPPorts = mkIf cfg.openPorts portsToOpen;

    systemd.slices.redpanda = {
      description = "Slice used to run Redpanda and rpk. Maximum priority for IO and CPU";
      before = [ "slices.target" ];
      sliceConfig = {
        MemoryAccounting = "true";
        IOAccounting = "true";
        CPUAccounting = "true";
        IOWeight = 1000;
        CPUWeight = 1000;
        MemoryMin = "2048M";
      };
    };

    systemd.services.redpanda-setup = {
      description = "Redpanda Setup";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      requires = [ "local-fs.target" "network-online.target" ];
      path = [ redpanda-rpk ];
      script = ''
        mkdir -p /opt
        ln -sfn ${redpanda} /opt/redpanda

        mkdir -p ${cfg.configDir}
        mkdir -p ${nodeConfig.redpanda.data_directory}
        cp ${nodeYaml} ${cfg.configDir}/redpanda.yaml

        rpk redpanda mode ${runMode} --config ${cfg.configDir}/redpanda.yaml
        rpk redpanda tune all $CPUSET --config ${cfg.configDir}/redpanda.yaml
      ''; # Do we need to include disks to tune also (--disks flag)?
      environment = {
        START_ARGS = "--check=true";
        HOME = "/root";
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "true";
        TimeoutStartSec = 900;
        KillMode = "process";
        SyslogLevelPrefix = "false";
      };
    };

    systemd.services.redpanda-config = {
      description = "Redpanda cluster config";
      wantedBy = [ "multi-user.target" ];
      after = [ "redpanda.service" ];
      path = [ redpanda-rpk pkgs.gawk ];
      script = ''
        rpk cluster config import -f ${clusterYaml} --config ${cfg.configDir}/redpanda.yaml
        echo "Cluster config status"
        rpk cluster config status --config ${cfg.configDir}/redpanda.yaml

        ${
          if cfg.admin == null then ""
          else ''
            rpk acl user delete ${cfg.admin.username} --config ${cfg.configDir}/redpanda.yaml
            rpk acl user create ${cfg.admin.username} -p $(cat ${cfg.admin.password}) --mechanism ${cfg.admin.saslMechanism} --config ${cfg.configDir}/redpanda.yaml
          ''
        }

        while IFS= read -r line; do
          if [[ $(echo $line | awk '{print $3}') == "true" ]]; then
            echo "WARNING: Have to restart node $(echo $line | awk '{print $1}')"
            ${if cfg.autoRestart then "systemctl restart redpanda.service" else "echo 'Not restarting'"}
          fi
        done <<< $(rpk cluster config status --config ${cfg.configDir}/redpanda.yaml)
      '';  # TODO: Make better logic for restarting nodes, this logic is really bad for multi-node clusters
      environment = {
        HOME = "${cfg.configDir}";  # rpk doesn't work without HOME
      };
    };

    systemd.services.redpanda = {
      description = "Redpanda, the fastest queue in the West.";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" "network-online.target" "redpanda-setup.service" ];
      requires = [ "local-fs.target" "network-online.target" ];
      serviceConfig = {
        Type = "notify";
        TimeoutStartSec = 900;
        ExecStart = "${redpanda-rpk}/bin/rpk redpanda start $START_ARGS $CPUSET --config ${cfg.configDir}/redpanda.yaml --install-dir ${redpanda}";
        ExecStop = "${redpanda-rpk}/bin/rpk redpanda stop --timeout 5s --config ${cfg.configDir}/redpanda.yaml --install-dir ${redpanda}";
        TimeoutStopSec = "11s";
        KillMode = "process";
        Restart = "on-abnormal";
        # User = "redpanda";  # From recommended deployment we should run as redpanda user
        OOMScoreAdjust = "-950";
        SyslogLevelPrefix = "false";
        Slice = "redpanda.slice";
        AmbientCapabilities = "CAP_SYS_NICE";
      };
      environment = {
        START_ARGS = "--check=true";
        HOME = "${cfg.configDir}";
      };
    };
  };
}
