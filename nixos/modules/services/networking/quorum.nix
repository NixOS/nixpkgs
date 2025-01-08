{
  config,
  options,
  pkgs,
  lib,
  ...
}:
let

  inherit (lib)
    mkEnableOption
    mkIf
    lib.mkOption
    literalExpression
    types
    lib.optionalString
    ;

  cfg = config.services.quorum;
  opt = options.services.quorum;
  dataDir = "/var/lib/quorum";
  genesisFile = pkgs.writeText "genesis.json" (builtins.toJSON cfg.genesis);
  staticNodesFile = pkgs.writeText "static-nodes.json" (builtins.toJSON cfg.staticNodes);

in
{
  options = {

    services.quorum = {
      enable = lib.mkEnableOption "Quorum blockchain daemon";

      user = lib.mkOption {
        type = lib.types.str;
        default = "quorum";
        description = "The user as which to run quorum.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = cfg.user;
        defaultText = lib.literalExpression "config.${opt.user}";
        description = "The group as which to run quorum.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 21000;
        description = "Override the default port on which to listen for connections.";
      };

      nodekeyFile = lib.mkOption {
        type = lib.types.path;
        default = "${dataDir}/nodekey";
        description = "Path to the nodekey.";
      };

      staticNodes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "enode://dd333ec28f0a8910c92eb4d336461eea1c20803eed9cf2c056557f986e720f8e693605bba2f4e8f289b1162e5ac7c80c914c7178130711e393ca76abc1d92f57@0.0.0.0:30303?discport=0"
        ];
        description = "List of validator nodes.";
      };

      privateconfig = lib.mkOption {
        type = lib.types.str;
        default = "ignore";
        description = "Configuration of privacy transaction manager.";
      };

      syncmode = lib.mkOption {
        type = lib.types.enum [
          "fast"
          "full"
          "light"
        ];
        default = "full";
        description = "Blockchain sync mode.";
      };

      blockperiod = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = "Default minimum difference between two consecutive block's timestamps in seconds.";
      };

      permissioned = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Allow only a defined list of nodes to connect.";
      };

      rpc = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable RPC interface.";
        };

        address = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "Listening address for RPC connections.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 22004;
          description = "Override the default port on which to listen for RPC connections.";
        };

        api = lib.mkOption {
          type = lib.types.str;
          default = "admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul";
          description = "API's offered over the HTTP-RPC interface.";
        };
      };

      ws = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable WS-RPC interface.";
        };

        address = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "Listening address for WS-RPC connections.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8546;
          description = "Override the default port on which to listen for WS-RPC connections.";
        };

        api = lib.mkOption {
          type = lib.types.str;
          default = "admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul";
          description = "API's offered over the WS-RPC interface.";
        };

        origins = lib.mkOption {
          type = lib.types.str;
          default = "*";
          description = "Origins from which to accept websockets requests";
        };
      };

      genesis = lib.mkOption {
        type = lib.types.nullOr lib.types.attrs;
        default = null;
        example = lib.literalExpression ''
          {
                   alloc = {
                     a47385db68718bdcbddc2d2bb7c54018066ec111 = {
                       balance = "1000000000000000000000000000";
                     };
                   };
                   coinbase = "0x0000000000000000000000000000000000000000";
                   config = {
                     byzantiumBlock = 4;
                     chainId = 494702925;
                     eip150Block = 2;
                     eip155Block = 3;
                     eip158Block = 3;
                     homesteadBlock = 1;
                     isQuorum = true;
                     istanbul = {
                       epoch = 30000;
                       policy = 0;
                     };
                   };
                   difficulty = "0x1";
                   extraData = "0x0000000000000000000000000000000000000000000000000000000000000000f85ad59438f0508111273d8e482f49410ca4078afc86a961b8410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0";
                   gasLimit = "0x2FEFD800";
                   mixHash = "0x63746963616c2062797a616e74696e65201111756c7420746f6c6572616e6365";
                   nonce = "0x0";
                   parentHash = "0x0000000000000000000000000000000000000000000000000000000000000000";
                   timestamp = "0x00";
                   }'';
        description = "Blockchain genesis settings.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.quorum ];
    systemd.tmpfiles.rules = [
      "d '${dataDir}' 0770 '${cfg.user}' '${cfg.group}' - -"
    ];
    systemd.services.quorum = {
      description = "Quorum daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        PRIVATE_CONFIG = "${cfg.privateconfig}";
      };
      preStart = ''
        if [ ! -d ${dataDir}/geth ]; then
          if [ ! -d ${dataDir}/keystore ]; then
            echo ERROR: You need to create a wallet before initializing your genesis file, run:
            echo   # su -s /bin/sh - quorum
            echo   $ geth --datadir ${dataDir} account new
            echo and configure your genesis file accordingly.
            exit 1;
          fi
          ln -s ${staticNodesFile} ${dataDir}/static-nodes.json
          ${pkgs.quorum}/bin/geth --datadir ${dataDir} init ${genesisFile}
        fi
      '';
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${pkgs.quorum}/bin/geth \
                      --nodiscover \
                      --verbosity 5 \
                      --nodekey ${cfg.nodekeyFile} \
                      --istanbul.blockperiod ${toString cfg.blockperiod} \
                      --syncmode ${cfg.syncmode} \
                      ${lib.optionalString (cfg.permissioned) "--permissioned"} \
                      --mine --miner.threads 1 \
                      ${lib.optionalString (cfg.rpc.enable) "--rpc --rpcaddr ${cfg.rpc.address} --rpcport ${toString cfg.rpc.port} --rpcapi ${cfg.rpc.api}"} \
                      ${lib.optionalString (cfg.ws.enable) "--ws --ws.addr ${cfg.ws.address} --ws.port ${toString cfg.ws.port} --ws.api ${cfg.ws.api} --ws.origins ${cfg.ws.origins}"} \
                      --emitcheckpoints \
                      --datadir ${dataDir} \
                      --port ${toString cfg.port}'';
        Restart = "on-failure";

        # Hardening measures
        PrivateTmp = "true";
        ProtectSystem = "full";
        NoNewPrivileges = "true";
        PrivateDevices = "true";
        MemoryDenyWriteExecute = "true";
      };
    };
    users.users.${cfg.user} = {
      name = cfg.user;
      group = cfg.group;
      description = "Quorum daemon user";
      home = dataDir;
      isSystemUser = true;
    };
    users.groups.${cfg.group} = { };
  };
}
