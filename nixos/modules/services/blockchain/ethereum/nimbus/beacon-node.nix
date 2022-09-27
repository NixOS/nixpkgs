{ config, lib, pkgs, ... }:

let
  inherit (lib)
    escapeShellArg mdDoc concatStringsSep mkMerge
    toUpper boolToString length forEach optionals optionalAttrs
    types mkEnableOption mkOption mkIf literalExpression;

  cfg = config.services.nimbus-beacon-node;
in {
  options = {
    services = {
      nimbus-beacon-node = {
        enable = mkEnableOption (mdDoc "Nimbus Beacon Node service");

        package = mkOption {
          type = types.package;
          default = pkgs.nimbus;
          defaultText = literalExpression "pkgs.nimbus";
          description = mdDoc "Package to use as Go Ethereum node.";
        };

        service = {
          user = mkOption {
            type = types.str;
            default = "nimbus";
            description = mdDoc "Username for Nimbus beacon node service.";
          };

          group = mkOption {
            type = types.str;
            default = "nimbus";
            description = mdDoc "Group name for Nimbus beacon node service.";
          };
        };

        dataDir = mkOption {
          type = types.path;
          default = "/var/lib/nimbus-beacon-node";
          description = mdDoc "Directory for Nimbus beacon node blockchain data.";
        };

        network = mkOption {
          type = types.str;
          default = "mainnet";
          description = mdDoc "Name of beacon node network to connect to.";
        };

        log = {
          level = mkOption {
            type = types.enum ["trace" "debug" "info" "notice" "warn" "error" "fatal" "none"];
            default = "info";
            example = "debug";
            description = mdDoc "Logging level.";
          };

          format = mkOption {
            type = types.enum ["auto" "colors" "nocolors" "json"];
            default = "auto";
            example = "json";
            description = mdDoc "Logging formatting.";
          };
        };

        web3Urls = mkOption {
          type = types.listOf types.str;
          default = [];
          example = ["http://localhost:8551/"];
          description = mdDoc "Mandatory URL(s) for the Web3 RPC endpoints.";
        };

        jwtSecret = mkOption {
          type = types.path;
          default = null;
          example = "/var/run/nimbus/jwtsecret";
          description = mdDoc ''
            Path of file with 32 bytes long JWT secret for Auth RPC endpoint.
            Can be generated using 'openssl rand -hex 32'.
          '';
        };

        subAllSubnets = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc "Subscribe to all attestation subnet topics.";
        };

        doppelganger = mkOption {
          type = types.bool;
          default = true;
          description = mdDoc ''
            Protection against slashing due to double-voting.
            Means you will miss two attestations when restarting.
          '';
        };

        suggestedFeeRecipient = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Wallet address where transaction fee tips - priority fees,
            unburnt portion of gas fees - will be sent.
          '';
        };

        listenPort = mkOption {
          type = types.port;
          default = 9000;
          description = mdDoc "Listen port for libp2p protocol.";
        };

        discoverPort = mkOption {
          type = types.port;
          default = 9000;
          description = mdDoc "Listen port for libp2p protocol.";
        };

        nat = mkOption {
          type = types.str;
          default = "any";
          example = "extip:12.34.56.78";
          description = mdDoc ''
            Method for determining public address. (any, none, upnp, pmp, extip:<IP>)
          '';
        };

        metrics = {
          enable = lib.mkEnableOption (mdDoc "Nimbus beacon node metrics endpoint");
          address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = mdDoc "Metrics address for beacon node.";
          };
          port = mkOption {
            type = types.port;
            default = 9100;
            description = mdDoc "Metrics port for beacon node.";
          };
        };

        rest = {
          enable = lib.mkEnableOption (mdDoc "Nimbus beacon node REST API");
          address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = mdDoc "Listening address of the REST API server.";
          };

          port = mkOption {
            type = types.port;
            default = 5052;
            description = mdDoc "Port for the REST API server.";
          };
        };

        extraArgs = mkOption {
          type = types.listOf types.str;
          default = [];
          example = ["--num-threads=1" "--graffiti=1337_h4x0r"];
          description = mdDoc "Additional arguments passed to node.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = length cfg.web3Urls > 0;
        message = "Nimbus beacon node requires at least one Web3 URL in services.nimbus-beacon-node.web3Urls to work!"; }
    ];

    users.users = optionalAttrs (cfg.service.user == "nimbus") {
      nimbus = {
        group = cfg.service.group;
        home = cfg.dataDir;
        description = "Nimbus beacon node service user";
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.service.user == "nimbus") {
      nimbus = { };
    };

    systemd.services.nimbus-beacon-node = {
      description = "Nimbus Beacon Node (Ethereum consensus client)";

      serviceConfig = mkMerge [{
        User = cfg.service.user;
        Group = cfg.service.group;

        ExecStart = concatStringsSep " \\\n  " ([
          "${cfg.package}/bin/nimbus_beacon_node"
          "--network=${cfg.network}"
          "--data-dir=${cfg.dataDir}"
          "--log-level=${toUpper cfg.log.level}"
          "--log-format=${cfg.log.format}"
          "--nat=${cfg.nat}"
          "--tcp-port=${toString cfg.listenPort}"
          "--udp-port=${toString cfg.discoverPort}"
          "--subscribe-all-subnets=${boolToString cfg.subAllSubnets}"
          "--doppelganger-detection=${boolToString cfg.doppelganger}"
          "--rest=${boolToString cfg.rest.enable}"
        ] ++ optionals cfg.rest.enable [
          "--rest-address=${cfg.rest.address}"
          "--rest-port=${toString cfg.rest.port}"
        ] ++ [
          "--metrics=${boolToString cfg.metrics.enable}"
        ] ++ optionals cfg.metrics.enable [
          "--metrics-address=${cfg.metrics.address}"
          "--metrics-port=${toString cfg.metrics.port}"
        ] ++ (forEach cfg.web3Urls (u: "--web3-url=${u}"))
          ++ optionals (cfg.jwtSecret != null) ["--jwt-secret=${cfg.jwtSecret}"]
          ++ optionals (cfg.suggestedFeeRecipient != null) ["--suggested-fee-recipient=${cfg.suggestedFeeRecipient}"]
          ++ (forEach cfg.extraArgs escapeShellArg));

        WorkingDirectory = cfg.dataDir;
        TimeoutSec = 1200;
        Restart = "on-failure";
        # Don't restart when Doppelganger detection has been activated
        RestartPreventExitStatus = 129;
      }
      (mkIf (cfg.dataDir == "/var/lib/nimbus-beacon-node") {
        StateDirectory = "nimbus-beacon-node";
        StateDirectoryMode = "0750";
      })];
      wantedBy = [ "multi-user.target" ];
      requires = [ "network.target" ];
    };
  };

  meta = {
    doc = ./beacon-node.md;
    maintainers = with lib.maintainers; [ jakubgs ];
  };
}
