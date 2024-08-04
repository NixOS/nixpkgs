{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.bitcoin;
  inherit (lib) mkOption types concatStringsSep;
in
{
  port = 9332;
  extraOpts = {
    package = lib.mkPackageOption pkgs "prometheus-bitcoin-exporter" { };

    rpcUser = mkOption {
      type = types.str;
      default = "bitcoinrpc";
      description = ''
        RPC user name.
      '';
    };

    rpcPasswordFile = mkOption {
      type = types.path;
      description = ''
        File containing RPC password.
      '';
    };

    rpcScheme = mkOption {
      type = types.enum [ "http" "https" ];
      default = "http";
      description = ''
        Whether to connect to bitcoind over http or https.
      '';
    };

    rpcHost = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        RPC host.
      '';
    };

    rpcPort = mkOption {
      type = types.port;
      default = 8332;
      description = ''
        RPC port number.
      '';
    };

    refreshSeconds = mkOption {
      type = types.ints.unsigned;
      default = 300;
      description = ''
        How often to ask bitcoind for metrics.
      '';
    };

    extraEnv = mkOption {
      type = types.attrsOf types.str;
      default = {};
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
