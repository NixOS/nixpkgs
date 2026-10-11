{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.jellyfin;
in
{
  port = 9594;
  extraOpts = {
    url = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1";
      description = ''
        The full URL to Jellyfin, including port and urlbase
      '';
      example = "https://127.0.0.1:8906/jellyfin";
    };

    collector.activity.enable = lib.mkEnableOption "activity collector";

    package = lib.mkPackageOption pkgs "prometheus-jellyfin-exporter" { };

    apiKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing the Jellyfin API key
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      LoadCredential = lib.optionalString (cfg.apiKeyFile != null) "apikey:${cfg.apiKeyFile}";
      ExecStart = "${pkgs.writeShellScript "prometheus-jellyfin-exporter-wrapper" ''
        export JELLYFIN_TOKEN="$(cat $1)"
        export JELLYFIN_ADDRESS="${cfg.url}"
        ${cfg.package}/bin/jellyfin_exporter ${
          if cfg.collector.activity.enable then "--collector.activity" else ""
        }
      ''} \${CREDENTIALS_DIRECTORY}/apikey";
    };
  };
}
