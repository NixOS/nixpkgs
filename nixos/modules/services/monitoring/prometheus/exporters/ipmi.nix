{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  logPrefix = "services.prometheus.exporter.ipmi";
  cfg = config.services.prometheus.exporters.ipmi;
in
{
  port = 9290;

  extraOpts = {
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to configuration file.
      '';
    };

    webConfigFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to configuration file that can enable TLS or authentication.
      '';
    };
  };

  serviceOpts.serviceConfig = {
    ExecStart =
      lib.concatStringsSep " " (
        [
          "${pkgs.prometheus-ipmi-exporter}/bin/ipmi_exporter"
          "--web.listen-address ${cfg.listenAddress}:${toString cfg.port}"
        ]
        ++ lib.optionals (cfg.webConfigFile != null) [
          "--web.config.file ${lib.escapeShellArg cfg.webConfigFile}"
        ]
        ++ lib.optionals (cfg.configFile != null) [
          "--config.file ${lib.escapeShellArg cfg.configFile}"
        ]
        ++ cfg.extraFlags
      );

    ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
  };
}
