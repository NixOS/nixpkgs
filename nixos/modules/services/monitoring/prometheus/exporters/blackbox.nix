{
  lib,
  options,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.blackbox;
  settingsFormat = pkgs.formats.yaml { };

  configFile =
    pkgs.runCommand "checked-blackbox-exporter.conf"
      {
        preferLocalBuild = true;
        nativeBuildInputs = [ pkgs.buildPackages.prometheus-blackbox-exporter ];
      }
      ''
        ln -s ${settingsFormat.generate "blackbox-exporter-unchecked.conf" cfg.settings} $out
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

  serviceOpts.serviceConfig = {
    AmbientCapabilities = [ "CAP_NET_RAW" ]; # for ping probes
    ExecStart = ''
      ${lib.getExe pkgs.prometheus-blackbox-exporter} \
        --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
        --config.file ${configFile} \
        ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
    '';
    ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
  };
}
