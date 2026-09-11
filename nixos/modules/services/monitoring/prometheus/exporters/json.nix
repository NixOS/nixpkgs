{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.json;
  inherit (lib)
    mkOption
    types
    escapeShellArg
    concatStringsSep
    mkRemovedOptionModule
    ;
in
{
  port = 7979;
  extraOpts = {
    configFile = mkOption {
      type = types.path;
      description = ''
        Path to configuration file.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-json-exporter}/bin/json_exporter \
          --config.file ${escapeShellArg cfg.configFile} \
          --web.listen-address="${cfg.listenAddress}:${toString cfg.port}" \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
  imports = [
    (mkRemovedOptionModule [ "url" ] ''
      This option was removed. The URL of the endpoint serving JSON
      must now be provided to the exporter by prometheus via the url
      parameter `target'.

      In prometheus a scrape URL would look like this:

        http://some.json-exporter.host:7979/probe?target=https://example.com/some/json/endpoint

      For more information, take a look at the official documentation
      (https://github.com/prometheus-community/json_exporter) of the json_exporter.
    '')
    {
      options.warnings = options.warnings;
      options.assertions = options.assertions;
    }
  ];
}
