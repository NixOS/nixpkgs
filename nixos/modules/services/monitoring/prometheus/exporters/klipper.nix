{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.klipper;
  inherit (lib)
    lib.mkOption
    mkMerge
    mkIf
    types
    concatStringsSep
    any
    lib.optionalString
    ;
  moonraker = config.services.moonraker;
in
{
  port = 9101;
  extraOpts = {
    package = lib.mkPackageOption pkgs "prometheus-klipper-exporter" { };

    moonrakerApiKey = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        API Key to authenticate with the Moonraker APIs.
        Only needed if the host running the exporter is not a trusted client to Moonraker.
      '';
    };
  };
  serviceOpts = lib.mkMerge (
    [
      {
        serviceConfig = {
          ExecStart = concatStringsSep " " [
            "${cfg.package}/bin/prometheus-klipper-exporter"
            (optionalString (cfg.moonrakerApiKey != "") "--moonraker.apikey ${cfg.moonrakerApiKey}")
            "--web.listen-address ${cfg.listenAddress}:${toString cfg.port}"
            "${lib.concatStringsSep " " cfg.extraFlags}"
          ];
        };
      }
    ]
    ++ [
      (lib.mkIf config.services.moonraker.enable {
        after = [ "moonraker.service" ];
        requires = [ "moonraker.service" ];
      })
    ]
  );
}
