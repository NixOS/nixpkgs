{
  lib,
  utils,
  options,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.blackbox;
  settingsFormat = pkgs.formats.yaml { };
  dummyConfigFile =
    pkgs.runCommand "checked-blackbox-exporter.conf"
      {
        preferLocalBuild = true;
        nativeBuildInputs = [ pkgs.buildPackages.prometheus-blackbox-exporter ];
      }
      ''
        ${utils.genJqSecretsReplacementSnippetDummy cfg.settings "${placeholder "out"}"}
        blackbox_exporter --config.check --config.file $out
      '';
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "configFile" ] ''
      Use services.prometheus.exporters.blackbox.settings instead.
    '')
    (lib.mkRemovedOptionModule [ "enableConfigCheck" ] ''
      The configuration file is now always checked.
    '')
    {
      options.warnings = options.warnings;
      options.assertions = options.assertions;
    }
  ];

  port = 9115;
  extraOpts = {
    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = ''
        Structured configuration that is being written into blackbox' configFile option.

        See <https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md> for upstream documentation.

        Secrets can be passed using the corresponding `file`-options. (ex. username -> username_file)
        See the upstream documentation for available `file`-options.
      '';
    };
  };

  serviceOpts = {
    preStart = utils.genJqSecretsReplacementSnippet cfg.settings "/run/prometheus-blackbox-exporter/blackbox-exporter.conf";

    # just add it somewhere to it actually get build and the configuration gets validated at build time
    restartTriggers = [ dummyConfigFile ];

    serviceConfig = {
      AmbientCapabilities = [ "CAP_NET_RAW" ]; # for ping probes
      ExecStart = ''
        ${lib.getExe pkgs.prometheus-blackbox-exporter} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --config.file /run/prometheus-blackbox-exporter/blackbox-exporter.conf \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      RuntimeDirectory = "prometheus-blackbox-exporter";
    };
  };
}
