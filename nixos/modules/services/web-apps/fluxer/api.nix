{
  settingsToEnvVars,
  loadCredential,
  standardSystemdSettings,
  propagateDefaults,
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
    services.fluxer.api.settings = propagateDefaults 1500 cfg.settings;

    users = mkIf (cfg.enable && cfg.api.enable && cfg.api.user == "fluxer") {
      users.fluxer = {
        isSystemUser = true;
        group = "fluxer";
        description = "fluxer service account";
      };
      groups.fluxer = { };
    };

    systemd.services.fluxer-api = mkIf (cfg.enable && cfg.api.enable) (
      lib.mkMerge [
        standardSystemdSettings
        {
          enable = true;
          description = "Fluxer HTTP API";

          confinement.enable = lib.mkForce false;

          wantedBy = [ "fluxer.target" ];
          partOf = [ "fluxer.target" ];
          after = [
            "nats.service"
            "postgresql.service"
            "redis-fluxer.service"
            "meilisearch.service"
            "seaweedfs.service"
            "fluxer-svc.target"
          ];
          requires =
            (lib.optional cfg.aux.nats.enable "nats.service")
            ++ (lib.optional cfg.aux.pgsql.enable "postgresql.service")
            ++ (lib.optional cfg.aux.valkey.enable "redis-fluxer.service")
            ++ (lib.optional cfg.aux.meilisearch.enable "meilisearch.service")
            ++ (lib.optional cfg.aux.seaweedfs.enable "seaweedfs.service")
            ++ [ "fluxer-svc.target" ];
          environment = settingsToEnvVars cfg.api.settings;

          script = ''
            export HOME="$STATE_DIRECTORY"

            ${fluxer-server}/bin/fluxer-api
          '';

          serviceConfig = {
            BindReadOnlyPaths = [
              "-/run/postgresql/"
            ]
            ++ lib.optional (cfg.aux.valkey.enable) (dirOf config.services.redis.servers.fluxer.unixSocket);

            StateDirectory = "fluxer/api";
            RuntimeDirectory = "fluxer/api";
            LoadCredential = loadCredential cfg.api.settings;

            User = mkIf (cfg.api.user != null) cfg.api.user;
            SupplementaryGroups = lib.optional (cfg.aux.valkey.enable) (
              config.services.redis.servers.fluxer.group
            );
          };
        }
      ]
    );

    systemd.services.fluxer-api-worker = mkIf (cfg.enable && cfg.api.enable) (
      lib.mkMerge [
        standardSystemdSettings
        {
          enable = true;
          description = "Fluxer API background worker";

          wantedBy = [ "fluxer.target" ];
          partOf = [ "fluxer.target" ];
          after = [
            "nats.service"
            "postgresql.service"
            "redis-fluxer.service"
            "seaweedfs.service"
            "fluxer-svc.target"
          ];
          requires =
            (lib.optional cfg.aux.nats.enable "nats.service")
            ++ (lib.optional cfg.aux.pgsql.enable "postgresql.service")
            ++ (lib.optional cfg.aux.valkey.enable "redis-fluxer.service")
            ++ (lib.optional cfg.aux.meilisearch.enable "meilisearch.service")
            ++ (lib.optional cfg.aux.seaweedfs.enable "seaweedfs.service")
            ++ [ "fluxer-svc.target" ];
          environment = settingsToEnvVars cfg.api.settings;

          script = ''
            set -u
            export HOME="$STATE_DIRECTORY"

            ${fluxer-server}/bin/fluxer-api-worker
          '';

          serviceConfig = {
            BindReadOnlyPaths = [
              "-/run/postgresql/"
            ]
            ++ lib.optional (cfg.aux.valkey.enable) (dirOf config.services.redis.servers.fluxer.unixSocket);

            StateDirectory = "fluxer/api-worker";
            RuntimeDirectory = "fluxer/api-worker";
            LoadCredential = loadCredential cfg.api.settings;

            User = mkIf (cfg.api.user != null) cfg.api.user;
            SupplementaryGroups = lib.optional (cfg.aux.valkey.enable) (
              config.services.redis.servers.fluxer.group
            );
          };
        }
      ]
    );
  };
}
