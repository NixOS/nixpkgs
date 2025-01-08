{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.bind;
in
{
  port = 9119;
  extraOpts = {
    bindURI = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:8053/";
      description = ''
        HTTP XML API address of an Bind server.
      '';
    };
    bindTimeout = lib.mkOption {
      type = lib.types.str;
      default = "10s";
      description = ''
        Timeout for trying to get stats from Bind.
      '';
    };
    bindVersion = lib.mkOption {
      type = lib.types.enum [
        "xml.v2"
        "xml.v3"
        "auto"
      ];
      default = "auto";
      description = ''
        BIND statistics version. Can be detected automatically.
      '';
    };
    bindGroups = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "server"
          "view"
          "tasks"
        ]
      );
      default = [
        "server"
        "view"
      ];
      description = ''
        List of statistics to collect. Available: [server, view, tasks]
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-bind-exporter}/bin/bind_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --bind.pid-file /var/run/named/named.pid \
          --bind.timeout ${toString cfg.bindTimeout} \
          --bind.stats-url ${cfg.bindURI} \
          --bind.stats-version ${cfg.bindVersion} \
          --bind.stats-groups ${lib.concatStringsSep "," cfg.bindGroups} \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
