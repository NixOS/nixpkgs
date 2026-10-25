{
  settingsToEnvVars,
  loadCredential,
  standardSystemdSettings,
  ...
}:
{
  name,
  description,
  needsPostgres ? false,
  defaultPort ? 8090,
}:
{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.services.fluxer;
  hasFluxerUserDef = cfg.${name}.shard ? user && cfg.${name}.shard.user == "fluxer";
  hasUserDef = cfg.${name}.shard ? user && cfg.${name}.shard.user != null;
in
{
  config = {
    services.fluxer.${name} = {
      settings = {
        svc = {
          name = name;
          shard_count = lib.mkDefault 1;
          listen_host = lib.mkDefault "127.0.0.1";
          nats.url = cfg.settings.nats.url;
        };
      };
      router.settings = {
        svc.mode = "router";
        svc.port = lib.mkDefault defaultPort;
      };
      shard.settings = {
        svc.mode = "shard";
        svc.shard_id = 0;
        svc.port = lib.mkDefault (defaultPort + 1);
      };
    };

    users = mkIf (hasFluxerUserDef && cfg.enable && cfg.${name}.shard.enable) {
      users.fluxer = {
        isSystemUser = true;
        group = "fluxer";
        description = "fluxer service account";
      };
      groups.fluxer = { };
    };

    systemd.services."fluxer-${name}-router" = mkIf (cfg.enable && cfg.${name}.router.enable) (
      lib.mkMerge [
        standardSystemdSettings
        {
          enable = true;

          description = "Router for the Fluxer ${description} shards";
          wantedBy = [ "fluxer-svc.target" ];
          partOf = [
            "fluxer.target"
            "fluxer-svc.target"
          ];
          after = [ "nats.service" ];
          requires = lib.optional cfg.aux.nats.enable "nats.service";
          environment = settingsToEnvVars cfg.${name}.router.settings;

          script = ''
            set -u
            ${lib.getExe pkgs.fluxer-server.${name}}
          '';

          serviceConfig = {
            LoadCredential = loadCredential cfg.${name}.router.settings;
          };
        }
      ]
    );

    systemd.services."fluxer-${name}-shard" = mkIf (cfg.enable && cfg.${name}.shard.enable) (
      lib.mkMerge [
        standardSystemdSettings
        {
          enable = true;
          description = "Shard of the Fluxer ${description}";

          wantedBy = [ "fluxer-svc.target" ];
          partOf = [
            "fluxer.target"
            "fluxer-svc.target"
          ];
          after = [ "nats.service" ] ++ (lib.optional needsPostgres "postgresql.service");
          requires =
            (lib.optional cfg.aux.nats.enable "nats.service")
            ++ (lib.optional (needsPostgres && cfg.aux.pgsql.enable) "postgresql.service");

          environment = settingsToEnvVars cfg.${name}.shard.settings;

          script = ''
            set -u
            ${lib.getExe pkgs.fluxer-server.${name}}
          '';

          serviceConfig = {
            BindReadOnlyPaths = [
              "-/run/postgresql/"
            ];
            LoadCredential = loadCredential cfg.${name}.shard.settings;
            User = mkIf hasUserDef cfg.${name}.shard.user;
          };
        }
      ]
    );
  };
}
