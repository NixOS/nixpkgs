{ config, lib, pkgs, ... }:
let

  cfg = config.services.lighthouse;
in {

  options = {
    services.lighthouse = {
      beacon = lib.mkOption {
        description = "Beacon node";
        default = {};
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Lightouse Beacon node";

            dataDir = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/lighthouse-beacon";
              description = ''
                Directory where data will be stored. Each chain will be stored under it's own specific subdirectory.
              '';
            };

            address = lib.mkOption {
              type = lib.types.str;
              default = "0.0.0.0";
              description = ''
                Listen address of Beacon node.
              '';
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 9000;
              description = ''
                Port number the Beacon node will be listening on.
              '';
            };

            openFirewall = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Open the port in the firewall
              '';
            };

            disableDepositContractSync = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Explicitly disables syncing of deposit logs from the execution node.
                This overrides any previous option that depends on it.
                Useful if you intend to run a non-validating beacon node.
              '';
            };

            execution = {
              address = lib.mkOption {
                type = lib.types.str;
                default = "127.0.0.1";
                description = ''
                  Listen address for the execution layer.
                '';
              };

              port = lib.mkOption {
                type = lib.types.port;
                default = 8551;
                description = ''
                  Port number the Beacon node will be listening on for the execution layer.
                '';
              };

              jwtPath = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = ''
                  Path for the jwt secret required to connect to the execution layer.
                '';
              };
            };

            http = {
              enable = lib.mkEnableOption "Beacon node http api";
              port = lib.mkOption {
                type = lib.types.port;
                default = 5052;
                description = ''
                  Port number of Beacon node RPC service.
                '';
              };

              address = lib.mkOption {
                type = lib.types.str;
                default = "127.0.0.1";
                description = ''
                  Listen address of Beacon node RPC service.
                '';
              };
            };

            metrics = {
              enable = lib.mkEnableOption "Beacon node prometheus metrics";
              address = lib.mkOption {
                type = lib.types.str;
                default = "127.0.0.1";
                description = ''
                  Listen address of Beacon node metrics service.
                '';
              };

              port = lib.mkOption {
                type = lib.types.port;
                default = 5054;
                description = ''
                  Port number of Beacon node metrics service.
                '';
              };
            };

            extraArgs = lib.mkOption {
              type = lib.types.str;
              description = ''
                Additional arguments passed to the lighthouse beacon command.
              '';
              default = "";
              example = "";
            };
          };
        };
      };

      validator = lib.mkOption {
        description = "Validator node";
        default = {};
        type = lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable Lightouse Validator node.";
            };

            dataDir = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/lighthouse-validator";
              description = ''
                Directory where data will be stored. Each chain will be stored under it's own specific subdirectory.
              '';
            };

            beaconNodes = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = ["http://localhost:5052"];
              description = ''
                Beacon nodes to connect to.
              '';
            };

            metrics = {
              enable = lib.mkEnableOption "Validator node prometheus metrics";
              address = lib.mkOption {
                type = lib.types.str;
                default = "127.0.0.1";
                description = ''
                  Listen address of Validator node metrics service.
                '';
              };

              port = lib.mkOption {
                type = lib.types.port;
                default = 5056;
                description = ''
                  Port number of Validator node metrics service.
                '';
              };
            };

            extraArgs = lib.mkOption {
              type = lib.types.str;
              description = ''
                Additional arguments passed to the lighthouse validator command.
              '';
              default = "";
              example = "";
            };
          };
        };
      };

      network = lib.mkOption {
        type = lib.types.enum [ "mainnet" "gnosis" "chiado" "sepolia" "holesky" ];
        default = "mainnet";
        description = ''
          The network to connect to. Mainnet is the default ethereum network.
        '';
      };

      extraArgs = lib.mkOption {
        type = lib.types.str;
        description = ''
          Additional arguments passed to every lighthouse command.
        '';
        default = "";
        example = "";
      };
    };
  };

  config = lib.mkIf (cfg.beacon.enable || cfg.validator.enable) {

    environment.systemPackages = [ pkgs.lighthouse ] ;

    networking.firewall = lib.mkIf cfg.beacon.enable {
      allowedTCPPorts = lib.mkIf cfg.beacon.openFirewall [ cfg.beacon.port ];
      allowedUDPPorts = lib.mkIf cfg.beacon.openFirewall [ cfg.beacon.port ];
    };


    systemd.services.lighthouse-beacon = lib.mkIf cfg.beacon.enable {
      description = "Lighthouse beacon node (connect to P2P nodes and verify blocks)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      script = ''
        # make sure the chain data directory is created on first run
        mkdir -p ${cfg.beacon.dataDir}/${cfg.network}

        ${pkgs.lighthouse}/bin/lighthouse beacon_node \
          --disable-upnp \
          ${lib.optionalString cfg.beacon.disableDepositContractSync "--disable-deposit-contract-sync"} \
          --port ${toString cfg.beacon.port} \
          --listen-address ${cfg.beacon.address} \
          --network ${cfg.network} \
          --datadir ${cfg.beacon.dataDir}/${cfg.network} \
          --execution-endpoint http://${cfg.beacon.execution.address}:${toString cfg.beacon.execution.port} \
          --execution-jwt ''${CREDENTIALS_DIRECTORY}/LIGHTHOUSE_JWT \
          ${lib.optionalString cfg.beacon.http.enable '' --http --http-address ${cfg.beacon.http.address} --http-port ${toString cfg.beacon.http.port}''} \
          ${lib.optionalString cfg.beacon.metrics.enable '' --metrics --metrics-address ${cfg.beacon.metrics.address} --metrics-port ${toString cfg.beacon.metrics.port}''} \
          ${cfg.extraArgs} ${cfg.beacon.extraArgs}
      '';
      serviceConfig = {
        LoadCredential = "LIGHTHOUSE_JWT:${cfg.beacon.execution.jwtPath}";
        DynamicUser = true;
        Restart = "on-failure";
        StateDirectory = "lighthouse-beacon";
        ReadWritePaths = [ cfg.beacon.dataDir ];
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        RemoveIPC = true;
        SystemCallFilter = [ "@system-service" "~@privileged" ];
      };
    };

    systemd.services.lighthouse-validator = lib.mkIf cfg.validator.enable {
      description = "Lighthouse validtor node (manages validators, using data obtained from the beacon node via a HTTP API)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      script = ''
        # make sure the chain data directory is created on first run
        mkdir -p ${cfg.validator.dataDir}/${cfg.network}

        ${pkgs.lighthouse}/bin/lighthouse validator_client \
          --network ${cfg.network} \
          --beacon-nodes ${lib.concatStringsSep "," cfg.validator.beaconNodes} \
          --datadir ${cfg.validator.dataDir}/${cfg.network} \
          ${lib.optionalString cfg.validator.metrics.enable ''--metrics --metrics-address ${cfg.validator.metrics.address} --metrics-port ${toString cfg.validator.metrics.port}''} \
          ${cfg.extraArgs} ${cfg.validator.extraArgs}
      '';

      serviceConfig = {
        Restart = "on-failure";
        StateDirectory = "lighthouse-validator";
        ReadWritePaths = [ cfg.validator.dataDir ];
        CapabilityBoundingSet = "";
        DynamicUser = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        SystemCallFilter = [ "@system-service" "~@privileged" ];
      };
    };
  };
}
