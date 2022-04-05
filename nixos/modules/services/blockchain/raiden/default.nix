{ config, lib, pkgs, ... }:

with lib;

let
  eachRaiden = config.services.raiden;

  raidenOpts = { config, lib, name, ...}: {

    options = {

      enable = lib.mkEnableOption "Raiden Node";

      package = mkOption {
        default = pkgs.raiden;
        defaultText = literalExpression "pkgs.raiden";
        type = types.package;
        description = "Package to use as Raiden node.";
      };

      datadir = mkOption {
        type = types.str;
        default = "/var/lib/raiden/${name}";
        description = "Directory used by Raiden to store data.";
      };

      keystore-path = mkOption {
        type = types.nullOr types.str;
        default = "/var/lib/raiden/${name}";
        description = "Path to the Ethereum keystore directory.";
      };

      address = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The Ethereum address you would like Raiden to use.
          NOTE: A keystore file MUST exist for the chosen address!
        '';
      };

      password-file = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Text file containing the password for the provided account.
        '';
      };

      user-deposit-contract-address = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Hex-encoded address of the User Deposit contract.
        '';
      };

      network-id = mkOption {
        type = types.str;
        default = "mainnet";
        description = ''
          The name/id of the Ethereum network to run Raiden on.
        '';
      };

      environment-type = mkOption {
        type = types.enum ["production" "development"];
        default = "production";
        description = ''
          The "production" setting adds some safety measures and is
          mainly intended for running Raiden on the mainnet.
        '';
      };

      development-environment = mkOption {
        type = types.enum ["demo" "unstable"];
        default = "demo";
        description = ''
          Choose which set of services and transport servers should
          be used. Change this only when you are developing Raiden
          itself.
        '';
      };

      # Logging

      logging = {
        config = mkOption {
          type = types.listOf types.str;
          default = ["default:info"];
          description = "Log level configuration.";
        };

        debug = {
          enable = lib.mkEnableOption "Raiden Debug Logging";

          logfile-path = mkOption {
            type = types.str;
            default = "/var/log/raiden-${name}-XXX.log";
            description = "File path of the debug logfile.";
          };
        };

        file = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "File path for logging to file.";
        };

        json = mkOption {
          type = types.bool;
          default = true;
          description = "Output log lines in JSON format.";
        };
      };

      # Ethereum Node options

      ethereum = {
        sync-check = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Checks if the Ethereum node is synchronized against
            etherscan.
          '';
        };

        gas-price = mkOption {
          type = types.enum ["fast" "normal"];
          default = "fast";
          description = ''
          Set the gas price for Ethereum transactions.
          - fast: transactions are usually mined within 60 seconds
          - normal: transactions are usually mined within 5 minutes
          '';
        };

        rpc-endpoint = mkOption {
          type = types.nullOr types.str;
          default = "http://127.0.0.1:8545";
          description = ''
            "host:port" address of Ethereum JSON-RPC server. Also
            accepts a protocol prefix (http:// or https://) with
            optional port
          '';
        };
      };

      # RPC options

      rpc = {
        enable = lib.mkEnableOption "Raiden RPC API";

        api-address = mkOption {
          type = types.str;
          default = "127.0.0.1:5001";
          description = "host:port for the RPC server to listen on.";
        };

        enable-tracing = mkOption {
          type = types.bool;
          default = false;
          description = "Enable Jaeger tracing logs.";
        };

        cors-domains = mkOption {
          type = types.listOf types.str;
          default = [ "http://localhost:*/*" ];
          description = "List of domains to accept cross origin requests.";
        };

        web-ui = mkOption {
          type = types.bool;
          default = true;
          description = "Start with or without the web interface.";
        };
      };

      # Path-Finding Services

      path-finding = {
        enable = lib.mkEnableOption "Raiden Path-Finder Service";

        service-address = mkOption {
          type = types.str;
          default = "auto";
          description = "URL to the Raiden Path-Finding Service.";
          example = "https://pfs-ropsten.services-dev.raiden.network";
        };

        max-paths = mkOption {
          type = types.int;
          default = 3;
          description = "Set maximum number of paths to be requested from the Path-Finding Service.";
        };

        max-fee = mkOption {
          type = types.str;
          default = "50000000000000000";
          description = "Set max fee per request paid to the Path-Finding Service.";
        };

        iou-timeout = mkOption {
          type = types.int;
          default = 200000;
          description = "Number of blocks before a new IOU to the path finding service expires.";
        };

        enable-monitoring = mkOption {
          type = types.bool;
          default = true;
          description = "Enable broadcasting of balance proofs to the monitoring services.";
        };
      };
    };
  };
in

{

  ###### interface

  options = {
    services.raiden = mkOption {
      type = types.attrsOf (types.submodule raidenOpts);
      default = {};
      description = "Specification of one or more raiden instances.";
    };
  };

  ###### implementation

  config = mkIf (eachRaiden != {}) {

    environment.systemPackages = [
      pkgs.go-ethereum.geth
      pkgs.solc
    ] ++ flatten (mapAttrsToList (raidenName: cfg: [
      cfg.package
    ]) eachRaiden);

    systemd = {
      services = mapAttrs' (raidenName: cfg: (
        nameValuePair "raiden-${raidenName}" (mkIf cfg.enable {
        description = "Raiden node (${raidenName})";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          DynamicUser = true;
          Restart = "always";
          StateDirectory = "raiden/${raidenName}";

          # Hardening measures
          PrivateTmp = "true";
          ProtectSystem = "full";
          NoNewPrivileges = "true";
          PrivateDevices = "true";
        };

        preStart = mkIf (cfg.keystore-path != null) ''
          [ -r ${cfg.keystore-path} ] || exit 1
        '';
        script = ''
          ${cfg.package}/bin/raiden \
            --datadir ${cfg.datadir} \
            ${optionalString (cfg.address != null) ''--address ${cfg.address}''} \
            ${optionalString (cfg.keystore-path != null) ''--keystore-path ${cfg.keystore-path}''} \
            ${optionalString (cfg.password-file != null) ''--password-file ${cfg.password-file}''} \
            ${optionalString (cfg.user-deposit-contract-address != null) ''--user-deposit-contract-address ${cfg.user-deposit-contract-address}''} \
            --network-id ${cfg.network-id} \
            --environment-type ${cfg.environment-type} \
            ${optionalString (cfg.environment-type == "development") ''--development-environment ${cfg.development-environment}''} \
            --accept-disclaimer \
            --log-config ${strings.concatStringsSep "," cfg.logging.config} \
            ${optionalString (cfg.logging.file != null) ''--log-file ${cfg.logging.file}''} \
            ${optionalString cfg.logging.json ''--log-json''} \
            ${if cfg.logging.debug.enable then "--debug-logfile" else "--no-debug-logfile"} \
            --debug-logfile-path ${cfg.logging.debug.logfile-path} \
            ${if cfg.ethereum.sync-check then "--sync-check" else "--no-sync-check"} \
            --gas-price ${cfg.ethereum.gas-price} \
            --eth-rpc-endpoint ${cfg.ethereum.rpc-endpoint} \
            ${if !cfg.rpc.enable
              then "--no-rpc"
              else ''
                --rpc \
                --api-address ${cfg.rpc.api-address} \
                --rpccorsdomain "${strings.concatStringsSep "," cfg.rpc.cors-domains}" \
                ${if cfg.rpc.web-ui then "--web-ui" else "--no-web-ui"} \
              ''} \
            ${if !cfg.path-finding.enable
              then "--routing-mode private"
              else ''
                --routing-mode pfs \
                --pathfinding-service-address ${cfg.path-finding.service-address} \
                --pathfinding-max-paths ${toString cfg.path-finding.max-paths} \
                --pathfinding-max-fee ${toString cfg.path-finding.max-fee} \
                --pathfinding-iou-timeout ${toString cfg.path-finding.iou-timeout} \
                ${if cfg.path-finding.enable-monitoring
                  then "--enable-monitoring"
                  else "--no-enable-monitoring"} \
              ''} \
        '';
      }))) eachRaiden;

      tmpfiles.rules = map (name: "d /var/lib/raiden/${name} 0770 root root -") (attrNames eachRaiden);
    };
  };
}
