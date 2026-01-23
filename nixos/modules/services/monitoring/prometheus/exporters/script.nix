{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.script;
  inherit (lib)
    mkOption
    types
    literalExpression
    concatStringsSep
    ;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "script-exporter.yaml" cfg.settings;
in
{
  port = 9172;
  extraOpts = {
    settings = mkOption {
      type = (pkgs.formats.yaml { }).type;
      default = { };
      example = literalExpression ''
        {
          scripts = [
            { name = "sleep"; command = [ "sleep" ]; args = [ "5" ]; }
          ];
        }
      '';
      description = ''
        Free-form configuration for script_exporter, expressed as a Nix attrset and rendered to YAML.

        **Migration note:**
        The previous format using `script = "sleep 5"` is no longer supported. You must use `command` (list) and `args` (list), e.g. `{ command = [ "sleep" ]; args = [ "5" ]; }`.

        See the official documentation for all available options: <https://github.com/ricoberger/script_exporter#configuration-file>
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-script-exporter}/bin/script_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --config.files ${configFile} \
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
