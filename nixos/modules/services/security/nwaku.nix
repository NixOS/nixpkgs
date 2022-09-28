{ config, lib, pkgs, ... }:

let
  inherit (lib)
    types mkEnableOption mkOption mkIf mkPackageOptionMD
    forEach escapeShellArg mdDoc literalExpression
    optionals concatStringsSep stringLength boolToString;

  cfg = config.services.nwaku;
in {
  options = {
    services = {
      nwaku = {
        enable = mkEnableOption (mdDoc "Nim Waku node service.");

        package = mkPackageOptionMD pkgs "nwaku" { };

        protocols = mkOption {
          type = types.listOf types.str;
          default = ["relay" "filter" "swap" "lightpush"];
          example = ["relay" "store" "filter" "swap" "lightpush" "rln-relay" "relay-peer-exchange"];
          description = mdDoc "List of protocols to enable on the node.";
        };

        nodekey = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234";
          description = mdDoc ''
            P2P node private key as 64 char hex string.
            Use of nodekeyFile is recommended instead.
          '';
        };

        nodekeyFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/var/run/nwaku/nodekey";
          description = mdDoc ''
            Path to file containing WAKUNODE2_NODEKEY environment variable
            with the value of P2P node private key as 64 char hex string.
          '';
        };

        storeMessage = {
          db = {
            url = mkOption {
              type = types.str;
              default = "sqlite://var/lib/nwaku/store.sqlite3";
              description = mdDoc "The database URL for persistent storage.";
            };

            vacuum = mkOption {
              type = types.bool;
              default = false;
              description = mdDoc "Enable database vacuuming at start. Only supported by SQLite.";
            };

            migration = mkOption {
              type = types.bool;
              default = true;
              description = mdDoc "Enable database migration at start.";
            };
          };

          retentionPolicy = mkOption {
            type = types.str;
            default = "time:172800"; # 2 days
            description = mdDoc ''
              Message store retention policy. Time retention policy: 'time:<seconds>'.
              Capacity retention policy: 'capacity:<count>'. Set to 'none' to disable.
            '';
          };
        };

        tcpPort = mkOption {
          type = types.port;
          default = 60000;
          description = mdDoc "TCP listening port.";
        };

        maxConnections = mkOption {
          type = types.int;
          default = 50;
          description = mdDoc "Maximum allowed number of libp2p connections.";
        };

        keepAlive = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc "Enable keep-alive for idle connections.";
        };

        nat = mkOption {
          type = types.str;
          default = "any";
          example = "extip:12.34.56.78";
          description = mdDoc ''
            Method for determining public address. (any, none, upnp, pmp, extip:<IP>)
          '';
        };

        dns4DomainName = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "node.example.org";
          description = mdDoc ''
            The domain name resolving to the node's public IPv4 address.
          '';
        };

        dnsDiscovery = {
          enable = lib.mkEnableOption (mdDoc "Enable discovering nodes via DNS");

          url = mkOption {
            type = types.nullOr types.str;
            example = "enrtree://AOGECG2SPND25EEFMAJ5WF3KSGJNSGV356DSTL2YVLLZWIV6SAYBM@prod.nodes.status.im";
            description = mdDoc ''
              URL for DNS node list in format `enrtree://<key>@<fqdn>`.
            '';
          };
        };

        v5Discovery = {
          enable = lib.mkEnableOption (mdDoc "Enable Node Discovery v5.");

          bootstrapNodes = mkOption {
            type = types.listOf types.str;
            default = [];
            example = ["/dns4/node-01.do-ams3.status.prod.statusim.net/tcp/30303/p2p/16Uiu2HAm6HZZr7aToTvEBPpiys4UxajCTU97zj5v7RNR2gbniy1D"];
            description = mdDoc ''
              Text-encoded ENR for bootstrap node. Used when connecting to the network.
            '';
          };

          enrAutoUpdate = mkOption {
            type = types.bool;
            default = false;
            description = mdDoc ''
              Discovery can automatically update its ENR with the IP address and UDP port as
              seen by other nodes it communicates with. This option allows to enable/disable
              this functionality.
            '';
          };

          udpPort = mkOption {
            type = types.port;
            default = 9000;
            description = mdDoc "Listening UDP port for Node Discovery v5.";
          };
        };

        rest = {
          enable = lib.mkEnableOption (mdDoc "Enable Waku REST HTTP server.");

          admin = mkOption {
            type = types.bool;
            default = false;
            description = mdDoc "Enable access to REST HTTP Admin API.";
          };

          private = mkOption {
            type = types.bool;
            default = false;
            description = mdDoc "Enable access to REST HTTP Private API.";
          };

          address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = mdDoc "Listening address of the REST HTTP server.";
          };

          port = mkOption {
            type = types.port;
            default = 5052;
            description = mdDoc "Listening port of the REST HTTP server.";
          };
        };

        rpc = {
          enable = lib.mkEnableOption (mdDoc "Enable Waku JSON-RPC server.");

          admin = mkOption {
            type = types.bool;
            default = false;
            description = mdDoc "Enable access to JSON-RPC Admin API.";
          };

          private = mkOption {
            type = types.bool;
            default = false;
            description = mdDoc "Enable access to JSON-RPC Private API.";
          };

          address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = mdDoc "Listening address of the JSON-RPC server.";
          };

          port = mkOption {
            type = types.port;
            default = 5052;
            description = mdDoc "Listening port of the JSON-RPC server.";
          };
        };

        metrics = {
          enable = lib.mkEnableOption (mdDoc "Nim Waku node metrics endpoint.");

          logging = mkOption {
            type = types.bool;
            default = false;
            description = mdDoc "Enable metrics logging.";
          };

          address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = mdDoc "Listening address of the metrics server.";
          };

          port = mkOption {
            type = types.port;
            default = 8008;
            description = mdDoc "Listening HTTP port of the metrics server.";
          };
        };

        extraArgs = mkOption {
          type = types.listOf types.str;
          default = [];
          example = ["--eth-client-address=ws://localhost:8540/"];
          description = mdDoc "Additional arguments passed to node.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.nodekey != null -> stringLength cfg.nodekey == 64;
        message = "Nim Waku node key needs to be 64 characters long!"; }
      { assertion = cfg.dnsDiscovery.enable -> cfg.dnsDiscovery.url != null;
        message = "Nim Waku node requires ENR URL for DNS Discovery!"; }
      { assertion = cfg.v5Discovery.enable -> cfg.v5Discovery.bootstrapNode != null;
        message = "Nim Waku node requires a bootstrap node for V5 Discovery!"; }
    ];

    systemd.services.nwaku = {
      enable = true;
      description = "Nim Waku node";

      unitConfig = {
        ConditionFileNotEmpty = mkIf (cfg.nodekeyFile != null) [ cfg.nodekeyFile ];
      };

      serviceConfig = {
        DynamicUser = true;
        # Hardening measures
        PrivateTmp = "true";
        ProtectSystem = "full";
        NoNewPrivileges = "true";
        PrivateDevices = "true";
        MemoryDenyWriteExecute = "true";

        StateDirectory = "nwaku";
        RuntimeDirectory = "nwaku";
        Restart = "always";
        RestartSec = "5s";

        EnvironmentFile = mkIf (cfg.nodekeyFile != null) [ cfg.nodekeyFile ];

        ExecStart = concatStringsSep " \\\n  " ([
          "${cfg.package}/bin/wakunode2"
        ] ++ forEach cfg.protocols (p: "--${p}=true") ++ [
          "--nat=${cfg.nat}"
          "--tcp-port=${toString cfg.tcpPort}"
          "--max-connections=${toString cfg.maxConnections}"
          "--keep-alive=${boolToString cfg.keepAlive}"
          "--store-message-db-url=${cfg.storeMessage.db.url}"
          "--store-message-db-vacuum=${boolToString cfg.storeMessage.db.vacuum}"
          "--store-message-db-migration=${boolToString cfg.storeMessage.db.migration}"
          "--store-message-retention-policy=${cfg.storeMessage.retentionPolicy}"
        ] ++ [
          "--dns-discovery=${boolToString cfg.dnsDiscovery.enable}"
        ] ++ optionals cfg.dnsDiscovery.enable [
          "--dns-discovery-url=${cfg.dnsDiscovery.url}"
        ] ++ [
          "--discv5-discovery=${boolToString cfg.v5Discovery.enable}"
        ] ++ optionals cfg.v5Discovery.enable [
          "--discv5-udp-port=${toString cfg.v5Discovery.udpPort}"
          "--discv5-enr-auto-update=${boolToString cfg.v5Discovery.enrAutoUpdate}"
        ] ++ forEach cfg.v5Discovery.bootstrapNodes (node:
          "--discv5-bootstrap-node=${node}"
        ) ++ [
          "--rest=${boolToString cfg.rest.enable}"
        ] ++ optionals cfg.rest.enable [
          "--rest-admin=${boolToString cfg.rest.admin}"
          "--rest-private=${boolToString cfg.rest.private}"
          "--rest-address=${cfg.rest.address}"
          "--rest-port=${toString cfg.rest.port}"
        ] ++ [
          "--rpc=${boolToString cfg.rpc.enable}"
        ] ++ optionals cfg.rpc.enable [
          "--rpc-admin=${boolToString cfg.rpc.admin}"
          "--rpc-private=${boolToString cfg.rpc.private}"
          "--rpc-address=${cfg.rpc.address}"
          "--rpc-port=${toString cfg.rpc.port}"
        ] ++ [
          "--metrics-server=${boolToString cfg.metrics.enable}"
        ] ++ optionals cfg.metrics.enable [
          "--metrics-logging=${boolToString cfg.metrics.logging}"
          "--metrics-server-address=${cfg.metrics.address}"
          "--metrics-server-port=${toString cfg.metrics.port}"
        ] ++ optionals (cfg.nodekey != null) ["--nodekey=${cfg.nodekey}"]
          ++ optionals (cfg.dns4DomainName != null) ["--dns4-domain-name=${cfg.dns4DomainName}"]
          ++ (forEach cfg.extraArgs escapeShellArg));
      };

      wantedBy = [ "multi-user.target" ];
      requires = [ "network.target" "network-online.target" ];
      after = [ "network.target" "network-online.target" ];
    };
  };

  meta = {
    doc = ./nwaku.md;
    maintainers = with lib.maintainers; [ jakubgs ];
  };
}
