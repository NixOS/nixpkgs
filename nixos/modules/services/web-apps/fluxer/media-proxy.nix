{
  settingsToEnvVars,
  loadCredential,
  standardSystemdSettings,
  ...
}:
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.services.fluxer;
  fluxer-server = cfg.package;
in
{
  config = {
    services.fluxer.media-proxy.settings = {
      media_proxy = {
        host = "127.0.0.1"; # TODO verify
        mode = lib.mkDefault "upload";
        storage_backend = lib.mkDefault "s3";
      };
    };

    systemd.services.fluxer-media-proxy = mkIf (cfg.enable && cfg.media-proxy.enable) (
      lib.mkMerge [
        standardSystemdSettings
        {
          enable = true;
          description = "Fluxer high-throughput media transcoding proxy";

          wantedBy = [ "fluxer.target" ];
          partOf = [ "fluxer.target" ];
          after = [
            "nats.service"
            "seaweedfs.service"
          ];
          requires =
            (lib.optional cfg.aux.nats.enable "nats.service")
            ++ (lib.optional cfg.aux.seaweedfs.enable "seaweedfs.service");

          environment = settingsToEnvVars cfg.media-proxy.settings;

          script = ''
            set -u
            ${fluxer-server}/bin/fluxer-media-proxy
          '';

          serviceConfig = {
            LoadCredential = loadCredential cfg.media-proxy.settings;
            StateDirectory = "fluxer/media-proxy";
            RuntimeDirectory = "fluxer/media-proxy";
          };
        }
      ]
    );

  };
}
