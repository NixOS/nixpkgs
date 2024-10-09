{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.redfish;
  inherit (lib)
    mkOption
    types
    mkPackageOption
    optionalString
    concatStringsSep
    optionalAttrs
    ;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "redfish-config.yml" cfg.settings;
in
{
  port = 9610;
  extraOpts = {
    settings = mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        Configuration for redfish_exporter, see
        <https://github.com/jenningsloy318/redfish_exporter>
        for supported values.
      '';
    };

    loglevel = mkOption {
      type = types.enum [
        "debug"
        "info"
        "warn"
        "error"
        "fatal"
      ];
      default = "info";
      description = ''
        Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal].
      '';
    };
    logformat = mkOption {
      type = types.str;
      default = "logger:stderr";
      description = ''
        Set the log target and format. Example: "logger:syslog?appname=bob&local=7" or "logger:stdout?json=true"
      '';
    };

    webConfigFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/var/lib/redfish-exporter/webConfigFile.conf";
      description = ''
        [EXPERIMENTAL] Path to configuration file that can enable TLS or authentication.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-redfish-exporter}/bin/redfish_exporter \
          --config.file="${configFile}" \
          --web.listen-address=${cfg.listenAddress}:${toString cfg.port} \
          --log.level=${cfg.loglevel} \
          --log.format="${cfg.logformat}" \
          ${optionalString (cfg.webConfigFile != null) "--web.config.file=${cfg.webConfigFile}"} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
