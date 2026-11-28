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
  extraOpts = {
    package = lib.mkPackageOption pkgs "prometheus-borgmatic-exporter" { };
    configFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/borgmatic/config.yaml";
      description = ''
        The path to the borgmatic config file
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      ProtectSystem = false;
      ProtectHome = lib.mkForce false;
      ExecStart = ''
        ${lib.getExe cfg.package} run \
          --host ${cfg.listenAddress} \
          --port ${toString cfg.port} \
          --config ${toString cfg.configFile} \
          ${lib.concatMapStringsSep " " (f: lib.escapeShellArg f) cfg.extraFlags}
      '';
    };
  };
}
