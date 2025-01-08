{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.process;
  inherit (lib)
    lib.mkOption
    types
    literalExpression
    concatStringsSep
    ;
  configFile = pkgs.writeText "process-exporter.yaml" (builtins.toJSON cfg.settings);
in
{
  port = 9256;
  extraOpts = {
    settings.process_names = lib.mkOption {
      type = lib.types.listOf types.anything;
      default = [ ];
      example = lib.literalExpression ''
        [
          # Remove nix store path from process name
          { name = "{{.Matches.Wrapped}} {{ .Matches.Args }}"; cmdline = [ "^/nix/store[^ ]*/(?P<Wrapped>[^ /]*) (?P<Args>.*)" ]; }
        ]
      '';
      description = ''
        All settings expressed as an Nix attrset.

        Check the official documentation for the corresponding YAML
        settings that can all be used here: <https://github.com/ncabatoff/process-exporter>
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      ExecStart = ''
        ${pkgs.prometheus-process-exporter}/bin/process-exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --config.path ${configFile} \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      NoNewPrivileges = true;
      ProtectHome = true;
      ProtectSystem = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
    };
  };
}
