{ config, lib, pkgs, options }:

with lib;
let
  cfg = config.services.prometheus.exporters.mpd;
in
{
  port = 9806;
  extraOpts = {
    port = mkOption {
      type = types.port;
      default = "9806";
      description = ''
        Port to bind to
      '';
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Address to bind to
      '';
    };

    mpdPort = mkOption {
      type = types.port;
      default = 6600;
      description = ''
        Port of the MPD server
      '';
    };

    mpdHost = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Address of the MPD server
      '';
    };

  };

  serviceOpts.serviceConfig.ExecStart = ''${pkgs.prometheus-mpd-exporter}/bin/prometheus-mpd-exporter \
    --bind-addr ${cfg.host}                   \
    --bind-port ${builtins.toString cfg.port} \
    --mpd-server-addr ${cfg.mpdHost}          \
    --mpd-server-port ${builtins.toString cfg.mpdPort}
  '';
}

