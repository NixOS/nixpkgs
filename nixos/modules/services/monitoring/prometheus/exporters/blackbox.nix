{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  logPrefix = "services.prometheus.exporter.blackbox";
  cfg = config.services.prometheus.exporters.blackbox;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    escapeShellArg
    ;

  # This ensures that we can deal with string paths, path types and
  # store-path strings with context.
  coerceConfigFile =
    file:
    if (builtins.isPath file) || (lib.isStorePath file) then
      file
    else
      (
        lib.warn ''
          ${logPrefix}: configuration file "${file}" is being copied to the nix-store.
          If you would like to avoid that, please set enableConfigCheck to false.
        '' /.
        + file
      );
  checkConfigLocation =
    file:
    if lib.hasPrefix "/tmp/" file then
      throw "${logPrefix}: configuration file must not reside within /tmp - it won't be visible to the systemd service."
    else
      file;
  checkConfig =
    file:
    pkgs.runCommand "checked-blackbox-exporter.conf"
      {
        preferLocalBuild = true;
        nativeBuildInputs = [ pkgs.buildPackages.prometheus-blackbox-exporter ];
      }
      ''
        ln -s ${coerceConfigFile file} $out
        blackbox_exporter --config.check --config.file $out
      '';

  yamlFormat = pkgs.formats.yaml { };
in
{
  port = 9115;
  extraOpts = {
    configFile = mkOption {
      type = types.path;
      description = ''
        Path to configuration file.
      '';
    };
    config = mkOption {
      type = yamlFormat.type;
      default = null;
      description = ''
        Blackbox Exporter YAML configuration as a nix attrset

        Documentation assoicated with the configuration schema and layout, see:
        [Blackbox Exporter Configuration Docs](https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md)

        Secrets can be handled using `_path` options, but require that the service has access to the files.
        This can be achieved by either giving the blackbox-exporter user read perms to the secret file or adding the credentials to the systemd service
      '';
    };
    enableConfigCheck = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to run a correctness check for the configuration file. This depends
        on the configuration file residing in the nix-store. Paths passed as string will
        be copied to the store.
      '';
    };
  };

  serviceOpts =
    let
      configFileToUse =
        if cfg.config != null then
          yamlFormat.generate "blackbox-exporter-config.yaml" cfg.config
        else
          cfg.configFile;

      adjustedConfigFile =
        if cfg.enableConfigCheck then checkConfig configFileToUse else checkConfigLocation configFileToUse;
    in
    {
      serviceConfig = {
        DynamicUser = false;
        AmbientCapabilities = [ "CAP_NET_RAW" ]; # for ping probes
        ExecStart = ''
          ${pkgs.prometheus-blackbox-exporter}/bin/blackbox_exporter \
            --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
            --config.file ${escapeShellArg adjustedConfigFile} \
            ${concatStringsSep " \\\n  " cfg.extraFlags}
        '';
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
}
