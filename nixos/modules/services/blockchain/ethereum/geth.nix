{
  config,
  lib,
  pkgs,
  ...
}:
let
  eachGeth = config.services.geth;

  gethOpts =
    {
      config,
      lib,
      name,
      ...
    }:
    {

      options = {

        enable = lib.mkEnableOption "Go Ethereum Node";

        port = lib.mkOption {
          type = lib.types.port;
          default = 30303;
          description = "Port number Go Ethereum will be listening on, both TCP and UDP.";
        };

        http = {
          enable = lib.mkEnableOption "Go Ethereum HTTP API";
          address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Listen address of Go Ethereum HTTP API.";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 8545;
            description = "Port number of Go Ethereum HTTP API.";
          };

          apis = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = null;
            description = "APIs to enable over WebSocket";
            example = [
              "net"
              "eth"
            ];
          };
        };

        websocket = {
          enable = lib.mkEnableOption "Go Ethereum WebSocket API";
          address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Listen address of Go Ethereum WebSocket API.";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 8546;
            description = "Port number of Go Ethereum WebSocket API.";
          };

          apis = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = null;
            description = "APIs to enable over WebSocket";
            example = [
              "net"
              "eth"
            ];
          };
        };

        authrpc = {
          enable = lib.mkEnableOption "Go Ethereum Auth RPC API";
          address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Listen address of Go Ethereum Auth RPC API.";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 8551;
            description = "Port number of Go Ethereum Auth RPC API.";
          };

          vhosts = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = [ "localhost" ];
            description = "List of virtual hostnames from which to accept requests.";
            example = [
              "localhost"
              "geth.example.org"
            ];
          };

          jwtsecret = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Path to a JWT secret for authenticated RPC endpoint.";
            example = "/var/run/geth/jwtsecret";
          };
        };

        metrics = {
          enable = lib.mkEnableOption "Go Ethereum prometheus metrics";
          address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Listen address of Go Ethereum metrics service.";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 6060;
            description = "Port number of Go Ethereum metrics service.";
          };
        };

        network = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.enum [
              "holesky"
              "sepolia"
            ]
          );
          default = null;
          description = "The network to connect to. Mainnet (null) is the default ethereum network.";
        };

        syncmode = lib.mkOption {
          type = lib.types.enum [
            "snap"
            "fast"
            "full"
            "light"
          ];
          default = "snap";
          description = "Blockchain sync mode.";
        };

        gcmode = lib.mkOption {
          type = lib.types.enum [
            "full"
            "archive"
          ];
          default = "full";
          description = "Blockchain garbage collection mode.";
        };

        maxpeers = lib.mkOption {
          type = lib.types.int;
          default = 50;
          description = "Maximum peers to connect to.";
        };

        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Additional arguments passed to Go Ethereum.";
          default = [ ];
        };

        package = lib.mkPackageOption pkgs [ "go-ethereum" "geth" ] { };
      };
    };
in

{

  ###### interface

  options = {
    services.geth = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule gethOpts);
      default = { };
      description = "Specification of one or more geth instances.";
    };
  };

  ###### implementation

  config = lib.mkIf (eachGeth != { }) {

    environment.systemPackages = lib.flatten (
      lib.mapAttrsToList (gethName: cfg: [
        cfg.package
      ]) eachGeth
    );

    systemd.services = lib.mapAttrs' (
      gethName: cfg:
      let
        stateDir = "goethereum/${gethName}/${if (cfg.network == null) then "mainnet" else cfg.network}";
        dataDir = "/var/lib/${stateDir}";
      in
      (lib.nameValuePair "geth-${gethName}" (
        lib.mkIf cfg.enable {
          description = "Go Ethereum node (${gethName})";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          serviceConfig = {
            ExecStart =
              let
                args = lib.cli.toCommandLineShellGNU { } {
                  inherit (cfg)
                    syncmode
                    gcmode
                    port
                    maxpeers
                    ;
                  nousb = true;
                  ipcdisable = true;
                  datadir = dataDir;
                  ${cfg.network} = true;

                  http = cfg.http.enable;
                  "http.addr" = if cfg.http.enable then cfg.http.address else null;
                  "http.port" = if cfg.http.enable then cfg.http.port else null;
                  "http.api" = if cfg.http.apis != null then lib.concatStringsSep "," cfg.http.apis else null;

                  ws = cfg.websocket.enable;
                  "ws.addr" = if cfg.websocket.enable then cfg.websocket.address else null;
                  "ws.port" = if cfg.websocket.enable then cfg.websocket.port else null;
                  "ws.api" = if cfg.websocket.apis != null then lib.concatStringsSep "," cfg.websocket.apis else null;

                  metrics = cfg.metrics.enable;
                  "metrics.addr" = if cfg.metrics.enable then cfg.metrics.address else null;
                  "metrics.port" = if cfg.metrics.enable then cfg.metrics.port else null;

                  "authrpc.addr" = cfg.authrpc.address;
                  "authrpc.port" = cfg.authrpc.port;
                  "authrpc.vhosts" = lib.concatStringsSep "," cfg.authrpc.vhosts;
                  "authrpc.jwtsecret" =
                    if cfg.authrpc.jwtsecret != "" then cfg.authrpc.jwtsecret else "${dataDir}/geth/jwtsecret";
                };
              in
              "${lib.getExe cfg.package} ${args} ${lib.escapeShellArgs cfg.extraArgs}";

            DynamicUser = true;
            Restart = "always";
            StateDirectory = stateDir;

            # Hardening measures
            PrivateTmp = "true";
            ProtectSystem = "full";
            NoNewPrivileges = "true";
            PrivateDevices = "true";
            MemoryDenyWriteExecute = "true";
          };
        }
      ))
    ) eachGeth;

  };

}
