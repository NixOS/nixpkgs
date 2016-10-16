{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.electrum-server;

  configFile = pkgs.writeText "electrum.conf" ''
    [server]
    # hostname. set it to a FQDN in order to be reached from outside
    host = ${cfg.hostname}
    # paths
    # logfile = /var/log/electrum.log
    # ports
    electrum_rpc_port = ${toString cfg.rpcPort}
    stratum_tcp_port = ${toString cfg.stratumPort}
    # SSL
    ${optionalString (cfg.sslCert != null) "ssl_certfile = ${cfg.sslCert}"}
    ${optionalString (cfg.sslKey != null) "ssl_keyfile = ${cfg.sslKey}"}
    ${optionalString (cfg.stratumSSLPort != null) "stratum_tcp_ssl_port = ${toString cfg.stratumSSLPort}"}

    [leveldb]
    # path to your database
    path = ${cfg.dataDir}
    pruning_limit = ${toString cfg.pruningLimit}

    [bitcoind]
    bitcoind_host = ${cfg.bitcoindHost}
    bitcoind_port = ${toString cfg.bitcoindPort}
    bitcoind_user = ${cfg.bitcoindUser}
    bitcoind_password = ${cfg.bitcoindPassword}
  '';

in {
  options = {
    services.electrum-server = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Electrum server daemon";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/electrum-server";
        description = "Data directory for Electrum server database";
      };

      hostname = mkOption {
        type = types.str;
        default = "localhost";
        description = "Hostname to bind Electrum server to";
      };

      rpcPort = mkOption {
        type = types.int;
        default = 8000;
        description = "RPC port for Electrum server";
      };

      stratumPort = mkOption {
        type = types.int;
        default = 50001;
        description = "Stratum port for Electrum server";
      };

      stratumSSLPort = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 50002;
        description = "SSL Stratum port for Electrum server";
      };

      sslCert = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "SSL certificate to use.";
      };

      sslKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "SSL key to use.";
      };

      bitcoindHost = mkOption {
        type = types.str;
        default = "localhost";
        description = "Bitcoin server host to use with Electrum";
      };

      bitcoindPort = mkOption {
        type = types.int;
        default = 8332;
        description = "Bitcoin server port to use with Electrum";
      };

      user = mkOption {
        type = types.str;
        default = "electrum-server";
        description = "User to run Electrum server";
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = "Group to run Electrum server";
      };

      bitcoindUser = mkOption {
        type = types.str;
        default = "guest";
        description = "Bitcoin server user";
      };

      bitcoindPassword = mkOption {
        type = types.str;
        default = "guest";
        description = "Bitcoin server password. WARNING: it will be globally accessible in the Nix store!";
      };

      pruningLimit = mkOption {
        type = types.int;
        default = 100;
        description = "For each address, history will be pruned if it is longer than this limit";
      };

    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.sslCert != null || cfg.sslKey != null) {
      services.electrum-server.stratumSSLPort = mkDefault 50002;
    })

    { assertions = singleton {
        assertion = all (x: x == (cfg.stratumSSLPort != null)) [(cfg.sslCert != null) (cfg.sslKey != null)];
        message = "You should specify both SSL certificate and key for Electrum server";
      };

      users.extraUsers = mkIf (cfg.user == "electrum-server") {
        electrum-server = {
          uid = config.ids.uids.electrum-server;
          group = cfg.group;
          home = cfg.dataDir;
          createHome = true;
        };
      };

      systemd.services.electrum-server = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${pkgs.electrum-server}/bin/run_electrum_server.py --conf ${configFile}";
          PermissionsStartOnly = true;
        };

        preStart = ''
          if [ ! -d "${cfg.dataDir}" ]; then
            mkdir -p "${cfg.dataDir}"
            chown "${cfg.user}:${cfg.group}" "${cfg.dataDir}"
          fi
        '';
      };
    }
  ]);
}
