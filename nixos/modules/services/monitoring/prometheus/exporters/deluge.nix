{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.deluge;
  inherit (lib) mkOption types concatStringsSep;
in
{
  port = 9354;

  extraOpts = {
    delugeHost = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Hostname where deluge server is running.
      '';
    };

    delugePort = mkOption {
      type = types.port;
      default = 58846;
      description = ''
        Port where deluge server is listening.
      '';
    };

    delugeUser = mkOption {
      type = types.str;
      default = "localclient";
      description = ''
        User to connect to deluge server.
      '';
    };

    delugePassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Password to connect to deluge server.

        This stores the password unencrypted in the nix store and is thus considered unsafe. Prefer
        using the delugePasswordFile option.
      '';
    };

    delugePasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File containing the password to connect to deluge server.
      '';
    };

    exportPerTorrentMetrics = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable per-torrent metrics.

        This may significantly increase the number of time series depending on the number of
        torrents in your Deluge instance.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-deluge-exporter}/bin/deluge-exporter
      '';
      Environment =
        [
          "LISTEN_PORT=${toString cfg.port}"
          "LISTEN_ADDRESS=${toString cfg.listenAddress}"

          "DELUGE_HOST=${cfg.delugeHost}"
          "DELUGE_USER=${cfg.delugeUser}"
          "DELUGE_PORT=${toString cfg.delugePort}"
        ]
        ++ lib.optionals (cfg.delugePassword != null) [
          "DELUGE_PASSWORD=${cfg.delugePassword}"
        ]
        ++ lib.optionals cfg.exportPerTorrentMetrics [
          "PER_TORRENT_METRICS=1"
        ];
      EnvironmentFile = lib.optionalString (
        cfg.delugePasswordFile != null
      ) "/etc/deluge-exporter/password";
    };
  };
}
