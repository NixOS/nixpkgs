{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.script;
  configFile = pkgs.writeText "script-exporter.yaml" (builtins.toJSON cfg.settings);
in
{
  port = 9172;
  extraOpts = {
    settings.scripts = mkOption {
      type = with types; listOf (submodule {
        options = {
          name = mkOption {
            type = str;
            example = "sleep";
            description = lib.mdDoc "Name of the script.";
          };
          script = mkOption {
            type = str;
            example = "sleep 5";
            description = lib.mdDoc "Shell script to execute when metrics are requested.";
          };
          timeout = mkOption {
            type = nullOr int;
            default = null;
            example = 60;
            description = lib.mdDoc "Optional timeout for the script in seconds.";
          };
        };
      });
      example = literalExpression ''
        {
          scripts = [
            { name = "sleep"; script = "sleep 5"; }
          ];
        }
      '';
      description = lib.mdDoc ''
        All settings expressed as an Nix attrset.

        Check the official documentation for the corresponding YAML
        settings that can all be used here: <https://github.com/adhocteam/script_exporter#sample-configuration>
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-script-exporter}/bin/script_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --config.file ${configFile} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      NoNewPrivileges = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
    };
  };
}
