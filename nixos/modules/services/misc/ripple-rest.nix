{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.rippleRest;

  configFile = pkgs.writeText "ripple-rest-config.json" (builtins.toJSON {
    config_version = "2.0.3";
    debug = cfg.debug;
    port = cfg.port;
    host = cfg.host;
    ssl_enabled = cfg.ssl.enable;
    ssl = {
      key_path = cfg.ssl.keyPath;
      cert_path = cfg.ssl.certPath;
      reject_unathorized = cfg.ssl.rejectUnathorized;
    };
    db_path = cfg.dbPath;
    max_transaction_fee = cfg.maxTransactionFee;
    rippled_servers = cfg.rippleds;
  });

in {
  options.services.rippleRest = {
    enable = mkEnableOption "ripple rest";

    debug = mkEnableOption "debug for ripple-rest";

    host = mkOption {
      description = "Ripple rest host.";
      default = "localhost";
      type = types.str;
    };

    port = mkOption {
      description = "Ripple rest port.";
      default = 5990;
      type = types.int;
    };

    ssl = {
      enable = mkEnableOption "ssl";

      keyPath = mkOption {
        description = "Path to the ripple rest key file.";
        default = null;
        type = types.nullOr types.path;
      };


      certPath = mkOption {
        description = "Path to the ripple rest cert file.";
        default = null;
        type = types.nullOr types.path;
      };

      rejectUnathorized = mkOption {
        description = "Whether to reject unatohroized.";
        default = true;
        type = types.bool;
      };
    };

    dbPath = mkOption {
      description = "Ripple rest database path.";
      default = "${cfg.dataDir}/ripple-rest.db";
      type = types.path;
    };

    maxTransactionFee = mkOption {
      description = "Ripple rest max transaction fee.";
      default = 1000000;
      type = types.int;
    };

    rippleds = mkOption {
      description = "List of rippled servers.";
      default = [
        "wss://s1.ripple.com:443"
      ];
      type = types.listOf types.str;
    };

    dataDir = mkOption {
      description = "Ripple rest data directory.";
      default = "/var/lib/ripple-rest";
      type = types.path;
    };
  };

  config = mkIf (cfg.enable) {
    systemd.services.ripple-rest = {
      wantedBy = [ "multi-user.target"];
      after = ["network.target" ];
      environment.NODE_PATH="${pkgs.ripple-rest}/lib/node_modules/ripple-rest/node_modules";
      serviceConfig = {
        ExecStart = "${pkgs.nodejs}/bin/node ${pkgs.ripple-rest}/lib/node_modules/ripple-rest/server/server.js --config ${configFile}";
        User = "ripple-rest";
      };
    };

    users.extraUsers.postgres = {
      name = "ripple-rest";
      uid = config.ids.uids.ripple-rest;
      createHome = true;
      home = cfg.dataDir;
    };
  };
}
