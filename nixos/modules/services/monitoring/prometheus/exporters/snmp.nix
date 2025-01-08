{ config, lib, pkgs, options, ... }:

let
  logPrefix = "services.prometheus.exporters.snmp";
  cfg = config.services.prometheus.exporters.snmp;
  inherit (lib)
    lib.mkOption
    types
    literalExpression
    escapeShellArg
    concatStringsSep
    ;

  # This ensures that we can deal with string paths, path types and
  # store-path strings with context.
  coerceConfigFile = file:
    if (builtins.isPath file) || (lib.isStorePath file) then
      file
    else
      (lib.warn ''
        ${logPrefix}: configuration file "${file}" is being copied to the nix-store.
        If you would like to avoid that, please set enableConfigCheck to false.
        '' /. + file);

  checkConfig = file:
    pkgs.runCommand "checked-snmp-exporter-config.yml" {
      preferLocalBuild = true;
      nativeBuildInputs = [ pkgs.buildPackages.prometheus-snmp-exporter ];
    } ''
      ln -s ${coerceConfigFile file} $out
      snmp_exporter --dry-run --config.file $out
    '';
in
{
  port = 9116;
  extraOpts = {
    configurationPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a snmp exporter configuration file. Mutually exclusive with 'configuration' option.
      '';
      example = lib.literalExpression "./snmp.yml";
    };

    configuration = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      description = ''
        Snmp exporter configuration as nix attribute set. Mutually exclusive with 'configurationPath' option.
      '';
      example = {
        auths.public_v2 = {
          community = "public";
          version = 2;
        };
      };
    };

    enableConfigCheck = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to run a correctness check for the configuration file. This depends
        on the configuration file residing in the nix-store. Paths passed as string will
        be copied to the store.
      '';
    };

    logFormat = lib.mkOption {
      type = lib.types.enum ["logfmt" "json"];
      default = "logfmt";
      description = ''
        Output format of log messages.
      '';
    };

    logLevel = lib.mkOption {
      type = lib.types.enum ["debug" "info" "warn" "error"];
      default = "info";
      description = ''
        Only log messages with the given severity or above.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/root/prometheus-snmp-exporter.env";
      description = ''
        EnvironmentFile as defined in {manpage}`systemd.exec(5)`.

        Secrets may be passed to the service without adding them to the
        world-readable Nix store, by specifying placeholder variables as
        the option value in Nix and setting these variables accordingly in the
        environment file.

        Environment variables from this file will be interpolated into the
        config file using envsubst with this syntax:
        `$ENVIRONMENT ''${VARIABLE}`

        For variables to use see [Prometheus Configuration](https://github.com/prometheus/snmp_exporter#prometheus-configuration).

        If the file path is set to this option, the parameter
        `--config.expand-environment-variables` is implicitly added to
        `ExecStart`.

        Note that this file needs to be available on the host on which
        this exporter is running.
      '';
    };
  };
  serviceOpts = let
    uncheckedConfigFile = if cfg.configurationPath != null
                          then cfg.configurationPath
                          else "${pkgs.writeText "snmp-exporter-conf.yml" (builtins.toJSON cfg.configuration)}";
    configFile = if cfg.enableConfigCheck then
      checkConfig uncheckedConfigFile
    else
      uncheckedConfigFile;
    in {
    serviceConfig = {
      EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
      ExecStart = ''
        ${pkgs.prometheus-snmp-exporter}/bin/snmp_exporter \
          --config.file=${lib.escapeShellArg configFile} \
          ${lib.optionalString (cfg.environmentFile != null)
            "--config.expand-environment-variables"} \
          --log.format=${lib.escapeShellArg cfg.logFormat} \
          --log.level=${cfg.logLevel} \
          --web.listen-address=${cfg.listenAddress}:${toString cfg.port} \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
