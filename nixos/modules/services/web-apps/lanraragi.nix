{ pkgs, lib, config, ... }:

let
  cfg = config.services.lanraragi;
in
{
  meta.maintainers = with lib.maintainers; [ tomasajt ];

  options.services = {
    lanraragi = {
      enable = lib.mkEnableOption (lib.mdDoc "LANraragi");
      package = lib.mkPackageOptionMD pkgs "lanraragi" { };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = lib.mdDoc "Port for LANraragi's web interface.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/lanraragi-password";
        description = lib.mdDoc ''
          A file containing the password for LANraragi's admin interface.
        '';
      };

      redis = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 6379;
          description = lib.mdDoc "Port for LANraragi's Redis server.";
        };
        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/redis-lanraragi-password";
          description = lib.mdDoc ''
            A file containing the password for LANraragi's Redis server.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.redis.servers.lanraragi = {
      enable = true;
      port = cfg.redis.port;
      requirePassFile = cfg.redis.passwordFile;
    };

    systemd.services.lanraragi = {
      description = "LANraragi main service";
      after = [ "network.target" "redis-lanraragi.service" ];
      requires = [ "redis-lanraragi.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        DynamicUser = true;
        StateDirectory = "lanraragi";
        RuntimeDirectory = "lanraragi";
        LogsDirectory = "lanraragi";
        Restart = "on-failure";
        WorkingDirectory = "/var/lib/lanraragi";
      };
      environment = {
        "LRR_TEMP_DIRECTORY" = "/run/lanraragi";
        "LRR_LOG_DIRECTORY" = "/var/log/lanraragi";
        "LRR_NETWORK" = "http://*:${toString cfg.port}";
        "HOME" = "/var/lib/lanraragi";
      };
      preStart = ''
        REDIS_PASS=${lib.optionalString (cfg.redis.passwordFile != null) "$(head -n1 ${cfg.redis.passwordFile})"}
        cat > lrr.conf <<EOF
        {
          redis_address => "127.0.0.1:${toString cfg.redis.port}",
          redis_password => "$REDIS_PASS",
          redis_database => "0",
          redis_database_minion => "1",
          redis_database_config => "2",
          redis_database_search => "3",
        }
        EOF
      '' + lib.optionalString (cfg.passwordFile != null) ''
        PASS_HASH=$(
          PASS=$(head -n1 ${cfg.passwordFile}) ${cfg.package.perlEnv}/bin/perl -I${cfg.package}/share/lanraragi/lib -e \
            'use LANraragi::Controller::Config; print LANraragi::Controller::Config::make_password_hash($ENV{PASS})' \
            2>/dev/null
        )

        ${lib.getExe pkgs.redis} -h 127.0.0.1 -p ${toString cfg.redis.port} -a "$REDIS_PASS" <<EOF
          SELECT 2
          HSET LRR_CONFIG password $PASS_HASH
        EOF
      '';
    };
  };
}
