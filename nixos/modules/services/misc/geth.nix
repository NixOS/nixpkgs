{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.geth;

  homeDir = "/var/lib/geth/";

  httpRpcModules = ''[${lib.strings.concatStringsSep ", " (map(mod: "\"${mod}\"") cfg.httpRpcModules)}]'';

  gethConf = pkgs.writeText "geth.toml" ''
    [Eth]
    ${optionalString (cfg.syncMode != null) "SyncMode = \"${cfg.syncmode}\""}
    ${optionalString (cfg.minerThreads != null) "MinerThreads = ${cfg.minerThreads}"}
    ${optionalString (cfg.etherbase != null) "EtherBase = ${cfg.etherbase}"}

    [Node]
    ${optionalString (!cfg.enableUSB) "NoUSB = true"}
    ${optionalString (cfg.httpRpcAddr != null) "HTTPHost = \"${cfg.httpRpcaddr}\""}
    ${optionalString (cfg.httpRpcPort != null) "HTTPPort = ${cfg.httpRpcPort}"}
    ${optionalString (lib.lists.length cfg.httpRpcModules > 0) "HTTPModules = ${httpRpcModules}"}
  '';

in {

  options.services.geth = {

    enable = mkOption {
      description = "Enable the go-ethereum service.";
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.go-ethereum;
      defaultText = "pkgs.go-ethereum";
      description = "go-ethereum derivation to use.";
    };

    user = mkOption {
     default = "geth";
     description = "User account under which geth runs.";
    };

    # Base geth options

    enableUSB = mkOption {
      description = "Enable hardware wallet support.";
      type = types.bool;
      default = false;
    };

    syncMode = mkOption {
      description = "Blockchain sync mode.";
      type = types.nullOr types.str;
      default = null;
    };

    # Mining options

    enableMining = mkOption {
      description = "Enable mining.";
      type = types.bool;
      default = false;
    };

    minerThreads = mkOption {
      description = "Number of CPU threads to use for mining.";
      type = types.nullOr types.int;
      default = null;
    };

    etherbase = mkOption {
      description = "Public address for block mining rewards.";
      type = types.nullOr types.str;
      default = null;
    };

    # HTTP RPC options

    httpRpcEnable = mkOption {
      description = "Enable the HTTP-RPC server.";
      type = types.bool;
      default = false;
    };

    httpRpcAddr = mkOption {
      description = "HTTP-RPC server listening interface.";
      type = types.types.nullOr types.str;
      default = null;
    };

    httpRpcPort = mkOption {
      description = "HTTP-RPC server listening port.";
      type = types.types.nullOr types.int;
      default = null;
    };

    httpRpcModules = mkOption {
      description = "API's offered over the HTTP-RPC interface.";
      type = types.listOf types.str;
      default = [];
      example = [ "eth" "net" "web3" "personal" "clique" ];
    };

    # Extras

    extraOptions = mkOption {
      description = "Extra command line options for geth.";
      type = types.nullOr types.str;
      default = null;
    };

  };

  config = mkIf cfg.enable {

    users = mkIf (cfg.user == "geth") {
      extraUsers.geth = {
        uid = config.ids.uids.geth;
        home = homeDir;
        createHome = true;
        group = "geth";
      };

      extraGroups.geth = {
        gid = config.ids.uids.geth;
      };
    };

    systemd.services.geth = {
      description = "Go ethereum daemon";

      after = [ "network.target" "local-fs.target" "remote-fs.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''${pkgs.go-ethereum}/bin/geth --config ${gethConf} \
          ${optionalString cfg.enableMining "--mine"} \
          ${optionalString cfg.httpRpcEnable "--rpc"} \
          ${optionalString (cfg.extraOptions != null) "${cfg.extraOptions}"}
        '';
        User = cfg.user;
        RestartSec = "30s";
        Restart = "always";
        StartLimitInterval = "1m";
        PrivateTmp = true;
        PrivateDevices = !cfg.enableUSB;
        ProtectHome = true;
      };
    };

  };
}
