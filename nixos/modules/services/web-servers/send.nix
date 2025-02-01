{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.services.send;
in
{
  options = {
    services.send = {
      enable = lib.mkEnableOption "Send, a file sharing web sevice for ffsend.";

      package = lib.mkPackageOption pkgs "send" { };

      environment = mkOption {
        type =
          with types;
          attrsOf (
            nullOr (oneOf [
              bool
              int
              str
              (listOf int)
            ])
          );
        description = ''
          All the available config options and their defaults can be found here: https://github.com/timvisee/send/blob/master/server/config.js,
          some descriptions can found here: https://github.com/timvisee/send/blob/master/docs/docker.md#environment-variables

          Values under {option}`services.send.environment` will override the predefined values in the Send service.
            - Time/duration should be in seconds
            - Filesize values should be in bytes
        '';
        example = {
          DEFAULT_DOWNLOADS = 1;
          DETECT_BASE_URL = true;
          EXPIRE_TIMES_SECONDS = [
            300
            3600
            86400
            604800
          ];
        };
      };

      dataDir = lib.mkOption {
        type = types.path;
        readOnly = true;
        default = "/var/lib/send";
        description = ''
          Directory for uploaded files.
          Due to limitations in {option}`systemd.services.send.serviceConfig.DynamicUser`, this item is read only.
        '';
      };

      baseUrl = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Base URL for the Send service.
          Leave it blank to automatically detect the base url.
        '';
      };

      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The hostname or IP address for Send to bind to.";
      };

      port = lib.mkOption {
        type = types.port;
        default = 1443;
        description = "Port the Send service listens on.";
      };

      openFirewall = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open firewall ports for send";
      };

      redis = {
        createLocally = lib.mkOption {
          type = types.bool;
          default = true;
          description = "Whether to create a local redis automatically.";
        };

        name = lib.mkOption {
          type = types.str;
          default = "send";
          description = ''
            Name of the redis server.
            Only used if {option}`services.send.redis.createLocally` is set to true.
          '';
        };

        host = lib.mkOption {
          type = types.str;
          default = "localhost";
          description = "Redis server address.";
        };

        port = lib.mkOption {
          type = types.port;
          default = 6379;
          description = "Port of the redis server.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/agenix/send-redis-password";
          description = ''
            The path to the file containing the Redis password.

            If {option}`services.send.redis.createLocally` is set to true,
            the content of this file will be used as the password for the locally created Redis instance.

            Leave it blank if no password is required.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {

    services.send.environment.DETECT_BASE_URL = cfg.baseUrl == null;

    assertions = [
      {
        assertion = cfg.redis.createLocally -> cfg.redis.host == "localhost";
        message = "the redis host must be localhost if services.send.redis.createLocally is set to true";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

    services.redis = lib.optionalAttrs cfg.redis.createLocally {
      servers."${cfg.redis.name}" = {
        enable = true;
        bind = "localhost";
        port = cfg.redis.port;
      };
    };

    systemd.services.send = {
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        StateDirectory = "send";
        WorkingDirectory = cfg.dataDir;
        ReadWritePaths = cfg.dataDir;
        LoadCredential = lib.optionalString (
          cfg.redis.passwordFile != null
        ) "redis-password:${cfg.redis.passwordFile}";

        # Hardening
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        AmbientCapabilities = lib.optionalString (cfg.port < 1024) "cap_net_bind_service";
        DynamicUser = true;
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        RemoveIPC = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
      environment =
        {
          IP_ADDRESS = cfg.host;
          PORT = toString cfg.port;
          BASE_URL = if (cfg.baseUrl == null) then "http://${cfg.host}:${toString cfg.port}" else cfg.baseUrl;
          FILE_DIR = cfg.dataDir + "/uploads";
          REDIS_HOST = cfg.redis.host;
          REDIS_PORT = toString cfg.redis.port;
        }
        // (lib.mapAttrs (
          name: value:
          if lib.isList value then
            "[" + lib.concatStringsSep ", " (map (x: toString x) value) + "]"
          else if lib.isBool value then
            lib.boolToString value
          else
            toString value
        ) cfg.environment);
      after =
        [
          "network.target"
        ]
        ++ lib.optionals cfg.redis.createLocally [
          "redis-${cfg.redis.name}.service"
        ];
      description = "Send web service";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${lib.optionalString (cfg.redis.passwordFile != null) ''
          export REDIS_PASSWORD="$(cat $CREDENTIALS_DIRECTORY/redis-password)"
        ''}
        ${lib.getExe cfg.package}
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [ moraxyc ];
}
