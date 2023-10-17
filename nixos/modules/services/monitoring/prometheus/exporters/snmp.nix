{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.snmp;
in
{
  port = 9116;
  extraOpts = {
    configurationPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Path to a snmp exporter configuration file. Mutually exclusive with 'configuration', 'generator.configurationPath' and 'generator.configuration' options.
      '';
      example = literalExpression "./snmp.yml";
    };

    configuration = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = lib.mdDoc ''
        Snmp exporter configuration as nix attribute set. Mutually exclusive with 'configurationPath' and 'generator.configuration' options.
      '';
      example = {
        "default" = {
          "version" = 2;
          "auth" = {
            "community" = "public";
          };
        };
      };
    };

    generator = {
      configurationPath = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          Path to a snmp exporter configuration generator configuration. Mutually exclusive with 'configurationPath', 'configuration' and 'generator.configuration' options.
        '';
        example = literalExpression "./generator.yml";
      };

      configuration = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = lib.mdDoc ''
          Snmp exporter configuration generator configuration as nix attribute set. Mutually exclusive with 'configurationPath', 'configuration' and 'generator.configurationPath' options.
        '';
        example = {
          "modules" = {
            "if_mib" = {
              "walk" = [ "sysUpTime" "interfaces" "ifXTable" ];
              "lookups" = [
                {
                  "source_indexes" = [ "ifIndex" ];
                  "lookup" = "ifAlias";
                }
                {
                  "source_indexes" = [ "ifIndex" ];
                  "lookup" = "1.3.6.1.2.1.2.2.1.2";
                }
                {
                  "source_indexes" = [ "ifIndex" ];
                  "lookup" = "1.3.6.1.2.1.31.1.1.1.1";
                }
              ];
              "overrides" = {
                "ifAlias" = {
                  "ignore" = true;
                };
                "ifDescr" = {
                  "ignore" = true;
                };
                "ifName" = {
                  "ignore" = true;
                };
                "ifType" = {
                  "type" = "EnumAsInfo";
                };
              };
            };
          };
        };
      };

      mibDirs = mkOption {
        type = types.listOf types.path;
        default = [];
        description = lib.mdDoc ''
          Snmp exporter configuration generator MIBs directories as list of paths.
        '';
      };
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
    generatorConfigFile = if cfg.generator.configurationPath != null
                          then cfg.generator.configurationPath
                          else "${pkgs.writeText "snmp-exporter-generator.yml" (builtins.toJSON cfg.generator.configuration)}";

    generatedConfigFile = pkgs.runCommand "snmp.yml" { MIBDIRS = concatStringsSep ":" cfg.generator.mibDirs; } ''
      ln -s ${generatorConfigFile} ./generator.yml
      ${pkgs.prometheus-snmp-exporter.outPath}/bin/generator generate && mv snmp.yml $out
    '';

    configFile = if cfg.configurationPath != null
                 then cfg.configurationPath
                 else (
                   if cfg.configuration != null
                   then "${pkgs.writeText "snmp-exporter-conf.yml" (builtins.toJSON cfg.configuration)}"
                   else generatedConfigFile
                 );
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
