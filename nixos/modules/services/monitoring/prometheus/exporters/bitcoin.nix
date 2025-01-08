{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.bitcoin;
in
{
  port = 9332;
  extraOpts = {
    package = lib.mkPackageOption pkgs "prometheus-bitcoin-exporter" { };

    rpcUser = lib.mkOption {
      type = lib.types.str;
      default = "bitcoinrpc";
      description = ''
        RPC user name.
      '';
    };

    rpcPasswordFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        File containing RPC password.
      '';
    };

    rpcScheme = lib.mkOption {
      type = lib.types.enum [
        "http"
        "https"
      ];
      default = "http";
      description = ''
        Whether to connect to bitcoind over http or https.
      '';
    };

    rpcHost = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = ''
        RPC host.
      '';
    };

    rpcPort = lib.mkOption {
      type = lib.types.port;
      default = 8332;
      description = ''
        RPC port number.
      '';
    };

    refreshSeconds = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 300;
      description = ''
        How often to ask bitcoind for metrics.
      '';
    };

    extraEnv = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Extra environment variables for the exporter.
      '';
    };
  };
  serviceOpts = {
    script = ''
      export BITCOIN_RPC_PASSWORD=$(cat ${cfg.rpcPasswordFile})
      exec ${cfg.package}/bin/bitcoind-monitor.py
    '';

    environment = {
      BITCOIN_RPC_USER = cfg.rpcUser;
      BITCOIN_RPC_SCHEME = cfg.rpcScheme;
      BITCOIN_RPC_HOST = cfg.rpcHost;
      BITCOIN_RPC_PORT = toString cfg.rpcPort;
      METRICS_ADDR = cfg.listenAddress;
      METRICS_PORT = toString cfg.port;
      REFRESH_SECONDS = toString cfg.refreshSeconds;
    } // cfg.extraEnv;
  };
}
