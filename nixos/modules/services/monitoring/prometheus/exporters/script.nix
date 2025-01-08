{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.script;
  configFile = pkgs.writeText "script-exporter.yaml" (builtins.toJSON cfg.settings);
in
{
  port = 9172;
  extraOpts = {
    settings.scripts = lib.mkOption {
      type =
        lib.types.listOf (lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              example = "sleep";
              description = "Name of the script.";
            };
            script = lib.mkOption {
              type = lib.types.str;
              example = "sleep 5";
              description = "Shell script to execute when metrics are requested.";
            };
            timeout = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              example = 60;
              description = "Optional timeout for the script in seconds.";
            };
          };
        });
      example = lib.literalExpression ''
        {
          scripts = [
            { name = "sleep"; script = "sleep 5"; }
          ];
        }
      '';
      description = ''
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
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
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
