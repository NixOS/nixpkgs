{
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.kener;
  opt = options.services.kener;
  isRedisUnixSocket = lib.hasPrefix "/" cfg.redis.host;
in
{

  meta.maintainers = [ lib.maintainers.albertlarsan68 ];

  options = {
    services.kener = {
      enable = lib.mkEnableOption "Kener, this assumes a reverse proxy to be set";

      package = lib.mkPackageOption pkgs "kener" { };

      environmentFile = lib.mkOption {
        type = lib.types.path;
        default = null;
        description = "Environment file, to put KENER_SECRET_KEY and other sensible values.";
      };

      redis = {
        createLocally = lib.mkOption {
          description = ''
            Whether to configure a local Redis server for Kener.
            The connection is performed via Unix sockets by default,
            but that can be changed by disabling this option and
            configuring {option}`${opt.redis.host}` and {option}`${opt.redis.port}`.
          '';
          type = lib.types.bool;
          default = true;
        };
        host = lib.mkOption {
          type = lib.types.str;
          default = config.services.redis.servers.kener.unixSocket;
          defaultText = lib.literalExpression "config.services.redis.servers.kener.unixSocket";
          description = "The host that redis will listen on.";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 0;
          description = "The port that redis will listen on. Set to zero to disable TCP.";
        };
      };

      settings = lib.mkOption {
        type = lib.types.submodule { freeformType = with lib.types; attrsOf str; };
        default = { };
        example = {
          PORT = "4000";
          NODE_EXTRA_CA_CERTS = lib.literalExpression "config.security.pki.caBundle";
        };
        description = ''
          Additional configuration for Kener, see
          <https://kener.ing/docs/v4/setup/environment-variables>
          for supported values.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (
          config.services.kener.redis.createLocally
          -> (config.services.kener.redis.host == config.services.redis.servers.kener.unixSocket)
        );
        message = "createLocally should only be used with the local unix socket";
      }
    ];

    services.redis.servers = lib.mkIf cfg.redis.createLocally {
      kener = {
        enable = true;
        port = cfg.redis.port;
        bind = lib.mkIf (!isRedisUnixSocket) cfg.redis.host;
      };
    };

    services.kener.settings =
      let
        redisEnv =
          if isRedisUnixSocket then
            { REDIS_URL = "unix://${cfg.redis.host}"; }
          else
            {
              REDIS_URL = "redis://${cfg.redis.host}:${toString cfg.redis.port}";
            };
      in
      redisEnv
      // {
        NODE_ENV = lib.mkDefault "production";
        DATABASE_URL = lib.mkDefault "sqlite:///var/lib/kener/kener.sqlite.db";
        HOST = lib.mkDefault "127.0.0.1";
        PORT = lib.mkDefault "3001";
      };

    systemd.services.kener = {
      description = "Kener";
      after = [ "network.target" ] ++ lib.optional cfg.redis.createLocally "redis-kener.service";
      wantedBy = [ "multi-user.target" ];
      environment = cfg.settings;
      path = with pkgs; [ unixtools.ping ];
      serviceConfig = {
        Type = "simple";
        StateDirectory = "kener";
        StateDirectoryMode = "750";
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/kener-server";
        Restart = "on-failure";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = false; # enabling it breaks execution
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = 27;
        SupplementaryGroups = lib.mkIf (cfg.redis.createLocally && isRedisUnixSocket) [
          config.services.redis.servers.kener.group
        ];
      };
    };
  };
}
