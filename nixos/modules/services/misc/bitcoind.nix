{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.bitcoind;

  args = [
    "-disablewallet"
    "-server"
    "-txindex"
    "-datadir=${cfg.dataDir}"
    "-port=${toString cfg.port}"
    "-rpcbind=${cfg.rpcAddress}"
    "-rpcport=${toString cfg.rpcPort}"
    "-rpcuser=${cfg.rpcUser}"
    "-rpcpassword=${cfg.rpcPassword}"
  ] ++ map (x: "-rpcallowip=${x}") cfg.rpcAllowIp
    ++ cfg.extraOptions;

in {
  options = {
    services.bitcoind = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Bitcoin daemon";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/bitcoind";
        description = "Directory to contain blockchain";
      };

      port = mkOption {
        type = types.int;
        default = 8333;
        description = "Port for incoming connections";
      };

      rpcAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = "Address to which Bitcoin RPC listener is bound";
      };

      rpcPort = mkOption {
        type = types.int;
        default = 8332;
        description = "Port to which Bitcoin RPC listener is bound";
      };

      rpcAllowIp = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" ];
        description = "Allowed source IP addresses to connect to the daemon";
      };

      rpcUser = mkOption {
        type = types.str;
        default = "guest";
        description = "RPC user for logging in into bitcoind";
      };

      rpcPassword = mkOption {
        type = types.str;
        default = "guest";
        description = "RPC password for logging in into bitcoind. WARNING: It will be globally accessible in the Nix store!";
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Extra command line options for the Bitcoin daemon";
      };

    };
  };

  config = mkIf cfg.enable {

    users.extraUsers.bitcoind = {
      uid = config.ids.uids.bitcoind;
      group = "nogroup";
      home = cfg.dataDir;
      createHome = true;
    };

    systemd.services.bitcoind = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "bitcoind";
        Group = "nogroup";
        ExecStart = "${pkgs.altcoins.bitcoind}/bin/bitcoind ${escapeShellArgs args}";
        PermissionsStartOnly = true;
      };

      preStart = ''
        if [ ! -d "${cfg.dataDir}" ]; then
          mkdir -p "${cfg.dataDir}"
          chown bitcoind:nogroup "${cfg.dataDir}"
        fi
      '';
    };

  };
}
