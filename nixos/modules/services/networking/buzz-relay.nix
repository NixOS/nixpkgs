{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.buzz-relay;
  redisServer = config.services.redis.servers.buzz-relay;
  user = "buzz-relay";

  settingsType = lib.types.attrsOf (
    lib.types.nullOr (
      lib.types.oneOf [
        lib.types.bool
        lib.types.int
        lib.types.str
      ]
    )
  );

  toEnvValue = value: if lib.isBool value then lib.boolToString value else toString value;

  # The public HTTP(S) origin of relayUrl, for media links and CORS.
  publicOrigin = lib.removeSuffix "/" (
    lib.replaceStrings [ "wss://" "ws://" ] [ "https://" "http://" ] cfg.relayUrl
  );

  # The relay and `buzz-admin` read the same environment; null unsets a variable.
  environment = lib.mapAttrs (_: toEnvValue) (
    lib.filterAttrs (_: v: v != null) (
      {
        # The probe needs an S3 backend and fails startup without one.
        BUZZ_GIT_CONFORMANCE_PROBE = (cfg.settings.BUZZ_S3_ENDPOINT or null) != null;
      }
      // cfg.settings
    )
  );

  hardening = {
    CapabilityBoundingSet = "";
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProtectSystem = "strict";
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
      "~@resources"
    ];
    UMask = "0077";
  };

  # Runs buzz-admin as the relay's user, with its environment and secrets.
  adminWrapper = pkgs.writeShellScriptBin "buzz-relay-admin" ''
    if [ -t 0 ]; then io=--pty; else io=--pipe; fi
    exec ${lib.getExe' config.systemd.package "systemd-run"} "$io" ${
      lib.escapeShellArgs (
        [
          "--unit=buzz-relay-admin"
          "--quiet"
          "--wait"
          "--collect"
          "--service-type=exec"
          "--property=User=${user}"
          "--property=Group=${user}"
        ]
        ++ lib.optional (cfg.environmentFile != null) "--property=EnvironmentFile=${cfg.environmentFile}"
        ++ lib.mapAttrsToList (name: value: "--setenv=${name}=${value}") environment
        ++ [ (lib.getExe' cfg.package "buzz-admin") ]
      )
    } "$@"
  '';
in
{
  options.services.buzz-relay = {
    enable = lib.mkEnableOption "Buzz Nostr relay and workspace server daemon";

    package = lib.mkPackageOption pkgs "buzz-relay" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = ''
        IP address the relay (and the pairing relay) listen on. The default
        suits a reverse proxy on the same machine that terminates TLS for
        [](#opt-services.buzz-relay.relayUrl).
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port to listen on for WebSocket and HTTP API connections.";
    };

    relayUrl = lib.mkOption {
      type = lib.types.str;
      example = "wss://buzz.example.com";
      description = ''
        Public WebSocket URL of the relay. Media links and the allowed CORS
        origin are derived from it (`https://buzz.example.com/media`).
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the relay port (and the pairing relay's) in the
        firewall. Only useful with a [](#opt-services.buzz-relay.listenAddress)
        other than localhost.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.externalPath;
      default = null;
      example = "/run/secrets/buzz.env";
      description = ''
        Environment file with secrets, for example `BUZZ_RELAY_PRIVATE_KEY`
        (32-byte hex Nostr private key), `BUZZ_GIT_HOOK_HMAC_SECRET` (at least
        32 characters; without it the relay generates a new one at every
        start), `BUZZ_S3_ACCESS_KEY`, `BUZZ_S3_SECRET_KEY` and
        `TYPESENSE_API_KEY`.
      '';
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to set up a local PostgreSQL database `buzz-relay`, reached over its Unix socket.";
      };

      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "postgresql://buzz:password@127.0.0.1:5432/buzz";
        description = "PostgreSQL connection URL, required when `createLocally` is false.";
      };
    };

    redis = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to set up a local Redis instance, reached over its Unix socket.";
      };

      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "redis://127.0.0.1:6379";
        description = "Redis connection URL, required when `createLocally` is false.";
      };
    };

    pairRelay = {
      enable = lib.mkEnableOption "the pairing relay, which the mobile app uses to pair with a desktop (its public URL goes in `settings.BUZZ_PAIRING_RELAY_URL`)";

      port = lib.mkOption {
        type = lib.types.port;
        default = 3001;
        description = "Port the pairing relay listens on.";
      };
    };

    members = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.enum [
          "member"
          "admin"
        ]
      );
      default = { };
      example = {
        "npub1examplexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" = "admin";
      };
      description = ''
        Relay members, as public keys (hex or npub) mapped to their role. They
        are added with `buzz-admin add-member` after every start. Removing a key
        here does not remove the member, and an existing member keeps its role;
        use `buzz-relay-admin remove-member` for both.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsType;
        options = {
          RELAY_OWNER_PUBKEY = lib.mkOption {
            type = lib.types.nullOr (lib.types.strMatching "[0-9a-f]{64}");
            default = null;
            example = "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798";
            description = ''
              Public key of the community's owner, as 64 lowercase hex
              characters (an `npub` can be converted with `nak decode`).
              Required while `BUZZ_REQUIRE_RELAY_MEMBERSHIP` is enabled.
            '';
          };

          BUZZ_REQUIRE_RELAY_MEMBERSHIP = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Whether only members can use the relay, as in upstream's
              production setup. The owner is always a member; add others with
              [](#opt-services.buzz-relay.members).
            '';
          };
        };
      };
      default = { };
      example = {
        BUZZ_ADMIN_HOST = "admin.buzz.example.com";
        BUZZ_S3_ENDPOINT = "http://127.0.0.1:3900";
        TYPESENSE_URL = "http://127.0.0.1:8108";
      };
      description = ''
        Environment variables that configure buzz-relay; see
        <https://github.com/block/buzz/blob/main/crates/buzz-relay/src/config.rs>.
        The module sets the listen address, URLs, database, Redis and upstream's
        production defaults (`BUZZ_REQUIRE_AUTH_TOKEN`, `BUZZ_ALLOW_NIP_OA_AUTH`);
        override any of them here, or set one to `null` to unset it. Put secrets
        in [](#opt-services.buzz-relay.environmentFile) instead.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.settings.BUZZ_REQUIRE_RELAY_MEMBERSHIP
          -> cfg.settings.RELAY_OWNER_PUBKEY != null && cfg.environmentFile != null;
        message = "services.buzz-relay: BUZZ_REQUIRE_RELAY_MEMBERSHIP needs settings.RELAY_OWNER_PUBKEY and a stable BUZZ_RELAY_PRIVATE_KEY in environmentFile.";
      }
      {
        assertion = cfg.database.createLocally || cfg.database.url != null;
        message = "services.buzz-relay.database.url must be set when services.buzz-relay.database.createLocally is disabled.";
      }
      {
        assertion = cfg.redis.createLocally || cfg.redis.url != null;
        message = "services.buzz-relay.redis.url must be set when services.buzz-relay.redis.createLocally is disabled.";
      }
      {
        assertion = cfg.pairRelay.enable -> cfg.settings.BUZZ_PAIRING_RELAY_URL or null != null;
        message = "services.buzz-relay.pairRelay needs the pairing relay's public URL in services.buzz-relay.settings.BUZZ_PAIRING_RELAY_URL.";
      }
    ];

    services.buzz-relay.settings = lib.mapAttrs (_: lib.mkDefault) {
      BUZZ_BIND_ADDR = "${cfg.listenAddress}:${toString cfg.port}";
      RELAY_URL = cfg.relayUrl;
      BUZZ_MEDIA_BASE_URL = "${publicOrigin}/media";
      BUZZ_CORS_ORIGINS = publicOrigin;
      # Upstream's production defaults (deploy/compose/.env.example).
      BUZZ_REQUIRE_AUTH_TOKEN = true;
      BUZZ_ALLOW_NIP_OA_AUTH = true;
      BUZZ_GIT_REPO_PATH = "/var/lib/buzz-relay/repos";
      # Upstream leaves migrations off; the relay can't start on an empty database.
      BUZZ_AUTO_MIGRATE = true;
      REDIS_URL =
        if cfg.redis.url != null then cfg.redis.url else "redis+unix://${redisServer.unixSocket}";
      DATABASE_URL =
        if cfg.database.url != null then
          cfg.database.url
        else
          "postgresql://${user}@localhost/${user}?host=/run/postgresql";
      # Read once https://github.com/block/buzz/pull/8071 is released; until then
      # the package patches the hook's interpreter instead.
      BUZZ_BASH_PATH = lib.getExe pkgs.bash;
    };

    environment.systemPackages = [ adminWrapper ];

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall (
      [ cfg.port ] ++ lib.optional cfg.pairRelay.enable cfg.pairRelay.port
    );

    users.users.${user} = {
      isSystemUser = true;
      group = user;
      description = "Buzz Relay service user";
      home = "/var/lib/buzz-relay";
      extraGroups = lib.optional cfg.redis.createLocally redisServer.group;
    };

    users.groups.${user} = { };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ user ];
      ensureUsers = [
        {
          name = user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers = lib.mkIf cfg.redis.createLocally {
      "buzz-relay" = {
        enable = true;
        # Unix socket only; avoids clashing with other Redis instances on TCP 6379.
        port = 0;
      };
    };

    systemd.services.buzz-relay = {
      description = "Buzz Nostr relay server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      requires =
        lib.optional cfg.database.createLocally "postgresql.target"
        ++ lib.optional cfg.redis.createLocally "redis-buzz-relay.service";
      after = [
        "network-online.target"
      ]
      ++ lib.optional cfg.database.createLocally "postgresql.target"
      ++ lib.optional cfg.redis.createLocally "redis-buzz-relay.service";

      inherit environment;

      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "buzz-relay";
        User = user;
        Group = user;
        StateDirectory = "buzz-relay";
        StateDirectoryMode = "0750";
        Restart = "always";
        RestartSec = 5;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      }
      // hardening;
    };

    systemd.services.buzz-pair-relay = lib.mkIf cfg.pairRelay.enable {
      description = "Buzz pairing relay";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment.BUZZ_PAIR_RELAY_BIND_ADDR = "${cfg.listenAddress}:${toString cfg.pairRelay.port}";
      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "buzz-pair-relay";
        DynamicUser = true;
        Restart = "always";
        RestartSec = 5;
      }
      // hardening;
    };

    systemd.services.buzz-relay-members = lib.mkIf (cfg.members != { }) {
      description = "Add the configured Buzz relay members";
      wantedBy = [ "multi-user.target" ];
      requires = [ "buzz-relay.service" ];
      # The relay creates the database schema on its first start.
      after = [ "buzz-relay.service" ];
      inherit environment;
      script = lib.concatStrings (
        lib.mapAttrsToList (pubkey: role: ''
          ${lib.getExe' cfg.package "buzz-admin"} add-member --pubkey ${lib.escapeShellArg pubkey} --role ${role}
        '') cfg.members
      );
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        # Retries until the relay has migrated the database.
        Restart = "on-failure";
        RestartSec = 5;
        User = user;
        Group = user;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      }
      // hardening;
    };
  };

  meta = {
    doc = ./buzz-relay.md;
    maintainers = with lib.maintainers; [ kleinbem ];
  };
}
