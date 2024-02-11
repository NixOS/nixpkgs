{ config, lib, options, pkgs, ... }:

let
  cfg = config.services.wasabibackend;
  opt = options.services.wasabibackend;

  inherit (lib) literalExpression mkEnableOption mkIf mkOption optionalAttrs optionalString types;

  confOptions = {
      BitcoinRpcConnectionString = "${cfg.rpc.user}:${cfg.rpc.password}";
  } // optionalAttrs (cfg.network == "mainnet") {
      Network = "Main";
      MainNetBitcoinP2pEndPoint = "${cfg.endpoint.ip}:${toString cfg.endpoint.port}";
      MainNetBitcoinCoreRpcEndPoint = "${cfg.rpc.ip}:${toString cfg.rpc.port}";
  } // optionalAttrs (cfg.network == "testnet") {
      Network = "TestNet";
      TestNetBitcoinP2pEndPoint = "${cfg.endpoint.ip}:${toString cfg.endpoint.port}";
      TestNetBitcoinCoreRpcEndPoint = "${cfg.rpc.ip}:${toString cfg.rpc.port}";
  } // optionalAttrs (cfg.network == "regtest") {
      Network = "RegTest";
      RegTestBitcoinP2pEndPoint = "${cfg.endpoint.ip}:${toString cfg.endpoint.port}";
      RegTestBitcoinCoreRpcEndPoint = "${cfg.rpc.ip}:${toString cfg.rpc.port}";
  };

  configFile = pkgs.writeText "wasabibackend.conf" (builtins.toJSON confOptions);

in {

  options = {

    services.wasabibackend = {
      enable = mkEnableOption (lib.mdDoc "Wasabi backend service");

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/wasabibackend";
        description = lib.mdDoc "The data directory for the Wasabi backend node.";
      };

      customConfigFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc "Defines the path to a custom configuration file that is copied to the user's directory. Overrides any config options.";
      };

      network = mkOption {
        type = types.enum [ "mainnet" "testnet" "regtest" ];
        default = "mainnet";
        description = lib.mdDoc "The network to use for the Wasabi backend service.";
      };

      endpoint = {
        ip = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = lib.mdDoc "IP address for P2P connection to bitcoind.";
        };

        port = mkOption {
          type = types.port;
          default = 8333;
          description = lib.mdDoc "Port for P2P connection to bitcoind.";
        };
      };

      rpc = {
        ip = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = lib.mdDoc "IP address for RPC connection to bitcoind.";
        };

        port = mkOption {
          type = types.port;
          default = 8332;
          description = lib.mdDoc "Port for RPC connection to bitcoind.";
        };

        user = mkOption {
          type = types.str;
          default = "bitcoin";
          description = lib.mdDoc "RPC user for the bitcoin endpoint.";
        };

        password = mkOption {
          type = types.str;
          default = "password";
          description = lib.mdDoc "RPC password for the bitcoin endpoint. Warning: this is stored in cleartext in the Nix store! Use `configFile` or `passwordFile` if needed.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = lib.mdDoc "File that contains the password of the RPC user.";
        };
      };

      user = mkOption {
        type = types.str;
        default = "wasabibackend";
        description = lib.mdDoc "The user as which to run the wasabibackend node.";
      };

      group = mkOption {
        type = types.str;
        default = cfg.user;
        defaultText = literalExpression "config.${opt.user}";
        description = lib.mdDoc "The group as which to run the wasabibackend node.";
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0770 '${cfg.user}' '${cfg.group}' - -"
    ];

    systemd.services.wasabibackend = {
      description = "wasabibackend server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = {
        DOTNET_PRINT_TELEMETRY_MESSAGE = "false";
        DOTNET_CLI_TELEMETRY_OPTOUT = "true";
      };
      preStart = ''
        mkdir -p ${cfg.dataDir}/.walletwasabi/backend
        ${if cfg.customConfigFile != null then ''
          cp -v ${cfg.customConfigFile} ${cfg.dataDir}/.walletwasabi/backend/Config.json
        '' else ''
          cp -v ${configFile} ${cfg.dataDir}/.walletwasabi/backend/Config.json
          ${optionalString (cfg.rpc.passwordFile != null) ''
            CONFIGTMP=$(mktemp)
            cat ${cfg.dataDir}/.walletwasabi/backend/Config.json | ${pkgs.jq}/bin/jq --arg rpconnection "${cfg.rpc.user}:$(cat "${cfg.rpc.passwordFile}")" '. + { BitcoinRpcConnectionString: $rpconnection }' > $CONFIGTMP
            mv $CONFIGTMP ${cfg.dataDir}/.walletwasabi/backend/Config.json
          ''}
        ''}
        chmod ug+w ${cfg.dataDir}/.walletwasabi/backend/Config.json
      '';
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.wasabibackend}/bin/WasabiBackend";
        ProtectSystem = "full";
      };
    };

    users.users.${cfg.user} = {
      name = cfg.user;
      group = cfg.group;
      description = "wasabibackend daemon user";
      home = cfg.dataDir;
      isSystemUser = true;
    };

    users.groups.${cfg.group} = {};

  };
}
