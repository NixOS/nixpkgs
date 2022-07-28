{ config, lib, pkgs, ... }:

with lib;

let
  eachGeth = config.services.geth;

  gethOpts = { config, lib, name, ...}: {

    options = {

      enable = lib.mkEnableOption "Go Ethereum Node";

      port = mkOption {
        type = types.port;
        default = 30303;
        description = lib.mdDoc "Port number Go Ethereum will be listening on, both TCP and UDP.";
      };

      http = {
        enable = lib.mkEnableOption "Go Ethereum HTTP API";
        address = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = lib.mdDoc "Listen address of Go Ethereum HTTP API.";
        };

        port = mkOption {
          type = types.port;
          default = 8545;
          description = lib.mdDoc "Port number of Go Ethereum HTTP API.";
        };

        apis = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = lib.mdDoc "APIs to enable over WebSocket";
          example = ["net" "eth"];
        };
      };

      websocket = {
        enable = lib.mkEnableOption "Go Ethereum WebSocket API";
        address = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = lib.mdDoc "Listen address of Go Ethereum WebSocket API.";
        };

        port = mkOption {
          type = types.port;
          default = 8546;
          description = lib.mdDoc "Port number of Go Ethereum WebSocket API.";
        };

        apis = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = lib.mdDoc "APIs to enable over WebSocket";
          example = ["net" "eth"];
        };
      };

      metrics = {
        enable = lib.mkEnableOption "Go Ethereum prometheus metrics";
        address = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = lib.mdDoc "Listen address of Go Ethereum metrics service.";
        };

        port = mkOption {
          type = types.port;
          default = 6060;
          description = lib.mdDoc "Port number of Go Ethereum metrics service.";
        };
      };

      network = mkOption {
        type = types.nullOr (types.enum [ "goerli" "rinkeby" "yolov2" "ropsten" ]);
        default = null;
        description = lib.mdDoc "The network to connect to. Mainnet (null) is the default ethereum network.";
      };

      syncmode = mkOption {
        type = types.enum [ "snap" "fast" "full" "light" ];
        default = "snap";
        description = lib.mdDoc "Blockchain sync mode.";
      };

      gcmode = mkOption {
        type = types.enum [ "full" "archive" ];
        default = "full";
        description = lib.mdDoc "Blockchain garbage collection mode.";
      };

      maxpeers = mkOption {
        type = types.int;
        default = 50;
        description = lib.mdDoc "Maximum peers to connect to.";
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc "Additional arguments passed to Go Ethereum.";
        default = [];
      };

      package = mkOption {
        default = pkgs.go-ethereum.geth;
        defaultText = literalExpression "pkgs.go-ethereum.geth";
        type = types.package;
        description = lib.mdDoc "Package to use as Go Ethereum node.";
      };
    };
  };
in

{

  ###### interface

  options = {
    services.geth = mkOption {
      type = types.attrsOf (types.submodule gethOpts);
      default = {};
      description = lib.mdDoc "Specification of one or more geth instances.";
    };
  };

  ###### implementation

  config = mkIf (eachGeth != {}) {

    environment.systemPackages = flatten (mapAttrsToList (gethName: cfg: [
      cfg.package
    ]) eachGeth);

    systemd.services = mapAttrs' (gethName: cfg: (
      nameValuePair "geth-${gethName}" (mkIf cfg.enable {
      description = "Go Ethereum node (${gethName})";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        StateDirectory = "goethereum/${gethName}/${if (cfg.network == null) then "mainnet" else cfg.network}";

        # Hardening measures
        PrivateTmp = "true";
        ProtectSystem = "full";
        NoNewPrivileges = "true";
        PrivateDevices = "true";
        MemoryDenyWriteExecute = "true";
      };

      script = ''
        ${cfg.package}/bin/geth \
          --nousb \
          --ipcdisable \
          ${optionalString (cfg.network != null) ''--${cfg.network}''} \
          --syncmode ${cfg.syncmode} \
          --gcmode ${cfg.gcmode} \
          --port ${toString cfg.port} \
          --maxpeers ${toString cfg.maxpeers} \
          ${if cfg.http.enable then ''--http --http.addr ${cfg.http.address} --http.port ${toString cfg.http.port}'' else ""} \
          ${optionalString (cfg.http.apis != null) ''--http.api ${lib.concatStringsSep "," cfg.http.apis}''} \
          ${if cfg.websocket.enable then ''--ws --ws.addr ${cfg.websocket.address} --ws.port ${toString cfg.websocket.port}'' else ""} \
          ${optionalString (cfg.websocket.apis != null) ''--ws.api ${lib.concatStringsSep "," cfg.websocket.apis}''} \
          ${optionalString cfg.metrics.enable ''--metrics --metrics.addr ${cfg.metrics.address} --metrics.port ${toString cfg.metrics.port}''} \
          ${lib.escapeShellArgs cfg.extraArgs} \
          --datadir /var/lib/goethereum/${gethName}/${if (cfg.network == null) then "mainnet" else cfg.network}
      '';
    }))) eachGeth;

  };

}
