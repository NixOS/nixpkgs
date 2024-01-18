{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.snmp;

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
    pkgs.runCommandLocal "checked-snmp-exporter-config.yml" {
      nativeBuildInputs = [ pkgs.buildPackages.prometheus-snmp-exporter ];
    } ''
      ln -s ${coerceConfigFile file} $out
      snmp_exporter --dry-run --config.file $out
    '';
in
{
  port = 9116;
  extraOpts = {
    configurationPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Path to a snmp exporter configuration file. Mutually exclusive with 'configuration' option.
      '';
      example = literalExpression "./snmp.yml";
    };

    configuration = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = lib.mdDoc ''
        Snmp exporter configuration as nix attribute set. Mutually exclusive with 'configurationPath' option.
      '';
      example = {
        auths.public_v2 = {
          community = "public";
          version = 2;
        };
      };
    };

    enableConfigCheck = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to run a correctness check for the configuration file. This depends
        on the configuration file residing in the nix-store. Paths passed as string will
        be copied to the store.
      '';
    };

    logFormat = mkOption {
      type = types.enum ["logfmt" "json"];
      default = "logfmt";
      description = lib.mdDoc ''
        Output format of log messages.
      '';
    };

    logLevel = mkOption {
      type = types.enum ["debug" "info" "warn" "error"];
      default = "info";
      description = lib.mdDoc ''
        Only log messages with the given severity or above.
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
      ExecStart = ''
        ${pkgs.prometheus-snmp-exporter}/bin/snmp_exporter \
          --config.file=${escapeShellArg configFile} \
          --log.format=${escapeShellArg cfg.logFormat} \
          --log.level=${cfg.logLevel} \
          --web.listen-address=${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
