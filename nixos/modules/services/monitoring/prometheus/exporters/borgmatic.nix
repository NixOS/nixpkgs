{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.borgmatic;
in
{
  port = 9996;
  extraOpts.configFile = lib.mkOption {
    type = lib.types.path;
    default = "/etc/borgmatic/config.yaml";
    description = ''
      The path to the borgmatic config file
    '';
  };

  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      ProtectSystem = false;
      ProtectHome = lib.mkForce false;
      ExecStart = ''
        ${pkgs.prometheus-borgmatic-exporter}/bin/borgmatic-exporter run \
          --port ${toString cfg.port} \
          --config ${toString cfg.configFile} \
          ${lib.concatMapStringsSep " " (f: lib.escapeShellArg f) cfg.extraFlags}
      '';
    };
  };
}
