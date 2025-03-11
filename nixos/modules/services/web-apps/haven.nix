{
  config,
  pkgs,
  lib,
  ...
}:
let
  defaultConfig = {
    OWNER_NPUB = cfg.ownerNpub;
    RELAY_URL = cfg.relayUrl;
    RELAY_PORT = toString cfg.port;
    RELAY_BIND_ADDRESS = "0.0.0.0"; # Can be set to a specific IP4 or IP6 address ("" for all interfaces)
    DB_ENGINE = "badger"; # badger, lmdb (lmdb works best with an nvme, otherwise you might have stability issues)
    LMDB_MAPSIZE = toString 0; # 0 for default (currently ~273GB), or set to a different size in bytes, e.g. 10737418240 for 10GB
    BLOSSOM_PATH = "blossom/";

    ## Private Relay Settings
    PRIVATE_RELAY_NAME = " ${cfg.ownerName}'s private relay";
    PRIVATE_RELAY_NPUB = cfg.ownerNpub;
    PRIVATE_RELAY_DESCRIPTION = "A safe place to store my drafts and ecash";
    PRIVATE_RELAY_ICON = "https://i.nostr.build/6G6wW.gif";

    ## Private Relay Rate Limiters
    PRIVATE_RELAY_EVENT_IP_LIMITER_TOKENS_PER_INTERVAL = toString 50;
    PRIVATE_RELAY_EVENT_IP_LIMITER_INTERVAL = toString 1;
    PRIVATE_RELAY_EVENT_IP_LIMITER_MAX_TOKENS = toString 100;
    PRIVATE_RELAY_ALLOW_EMPTY_FILTERS = "true";
    PRIVATE_RELAY_ALLOW_COMPLEX_FILTERS = "true";
    PRIVATE_RELAY_CONNECTION_RATE_LIMITER_TOKENS_PER_INTERVAL = toString 3;
    PRIVATE_RELAY_CONNECTION_RATE_LIMITER_INTERVAL = toString 5;
    PRIVATE_RELAY_CONNECTION_RATE_LIMITER_MAX_TOKENS = toString 9;

    ## Chat Relay Settings
    CHAT_RELAY_NAME = " ${cfg.ownerName}'s chat relay";
    CHAT_RELAY_NPUB = cfg.ownerNpub;
    CHAT_RELAY_DESCRIPTION = "a relay for private chats";
    CHAT_RELAY_ICON = "https://i.nostr.build/6G6wW.gif";
    CHAT_RELAY_WOT_DEPTH = toString 3;
    CHAT_RELAY_WOT_REFRESH_INTERVAL_HOURS = toString 24;
    CHAT_RELAY_MINIMUM_FOLLOWERS = toString 3;

    ## Chat Relay Rate Limiters
    CHAT_RELAY_EVENT_IP_LIMITER_TOKENS_PER_INTERVAL = toString 50;
    CHAT_RELAY_EVENT_IP_LIMITER_INTERVAL = toString 1;
    CHAT_RELAY_EVENT_IP_LIMITER_MAX_TOKENS = toString 100;
    CHAT_RELAY_ALLOW_EMPTY_FILTERS = "false";
    CHAT_RELAY_ALLOW_COMPLEX_FILTERS = "false";
    CHAT_RELAY_CONNECTION_RATE_LIMITER_TOKENS_PER_INTERVAL = toString 3;
    CHAT_RELAY_CONNECTION_RATE_LIMITER_INTERVAL = toString 3;
    CHAT_RELAY_CONNECTION_RATE_LIMITER_MAX_TOKENS = toString 9;

    ## Outbox Relay Settings
    OUTBOX_RELAY_NAME = " ${cfg.ownerName}'s outbox relay";
    OUTBOX_RELAY_NPUB = cfg.ownerNpub;
    OUTBOX_RELAY_DESCRIPTION = "a relay and Blossom server for public messages and media";
    OUTBOX_RELAY_ICON = "https://i.nostr.build/6G6wW.gif";

    ## Outbox Relay Rate Limiters
    OUTBOX_RELAY_EVENT_IP_LIMITER_TOKENS_PER_INTERVAL = toString 10;
    OUTBOX_RELAY_EVENT_IP_LIMITER_INTERVAL = toString 60;
    OUTBOX_RELAY_EVENT_IP_LIMITER_MAX_TOKENS = toString 100;
    OUTBOX_RELAY_ALLOW_EMPTY_FILTERS = "false";
    OUTBOX_RELAY_ALLOW_COMPLEX_FILTERS = "false";
    OUTBOX_RELAY_CONNECTION_RATE_LIMITER_TOKENS_PER_INTERVAL = toString 3;
    OUTBOX_RELAY_CONNECTION_RATE_LIMITER_INTERVAL = toString 1;
    OUTBOX_RELAY_CONNECTION_RATE_LIMITER_MAX_TOKENS = toString 9;

    ## Inbox Relay Settings
    INBOX_RELAY_NAME = " ${cfg.ownerName}'s inbox relay";
    INBOX_RELAY_NPUB = cfg.ownerNpub;
    INBOX_RELAY_DESCRIPTION = "send your interactions with my notes here";
    INBOX_RELAY_ICON = "https://i.nostr.build/6G6wW.gif";
    INBOX_PULL_INTERVAL_SECONDS = toString 600;

    ## Inbox Relay Rate Limiters
    INBOX_RELAY_EVENT_IP_LIMITER_TOKENS_PER_INTERVAL = toString 10;
    INBOX_RELAY_EVENT_IP_LIMITER_INTERVAL = toString 1;
    INBOX_RELAY_EVENT_IP_LIMITER_MAX_TOKENS = toString 20;
    INBOX_RELAY_ALLOW_EMPTY_FILTERS = "false";
    INBOX_RELAY_ALLOW_COMPLEX_FILTERS = "false";
    INBOX_RELAY_CONNECTION_RATE_LIMITER_TOKENS_PER_INTERVAL = toString 3;
    INBOX_RELAY_CONNECTION_RATE_LIMITER_INTERVAL = toString 1;
    INBOX_RELAY_CONNECTION_RATE_LIMITER_MAX_TOKENS = toString 9;

    ## Import Settings
    IMPORT_START_DATE = "2025-01-01";
    IMPORT_QUERY_INTERVAL_SECONDS = toString 600;
    IMPORT_SEED_RELAYS_FILE = "${pkgs.writeText "relays_import.json" (
      builtins.toJSON cfg.importRelays
    )}";

    ## Backup Settings
    BACKUP_PROVIDER = "none"; # s3, none (or leave blank to disable)
    BACKUP_INTERVAL_HOURS = toString 1;

    ## Generic S3 Bucket Backup Settings - REQUIRED IF BACKUP_PROVIDER="s3"
    S3_ACCESS_KEY_ID = "access";
    S3_SECRET_KEY = "secret";
    S3_ENDPOINT = "nyc3.digitaloceanspaces.com";
    S3_REGION = "nyc3";
    S3_BUCKET_NAME = "backups";

    ## Blastr Settings
    BLASTR_RELAYS_FILE = "${pkgs.writeText "relays_blastr.json" (builtins.toJSON cfg.blastrRelays)}";
  };

  cfg = config.services.haven;
in
{
  options.services.haven = {
    enable = lib.mkEnableOption "haven";

    package = lib.mkPackageOption pkgs "haven" { };

    port = lib.mkOption {
      default = 3355;
      type = lib.types.port;
      description = "Listen on this port.";
    };

    relayUrl = lib.mkOption {
      type = lib.types.str;
      description = "The URL of the relay.";
    };

    ownerNpub = lib.mkOption {
      type = lib.types.str;
      description = "The NPUB of the owner.";
    };

    ownerName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the owner. Used for relay names and descriptions.";
      default = "a nostrich";
    };

    blastrRelays = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of relay configurations for blastr";
      example = lib.literalExpression ''
        [
          "relay.example.com"
        ]
      '';
    };

    importRelays = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of relay configurations for importing historical events";
      example = lib.literalExpression ''
        [
          "relay.example.com"
        ]
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      apply = lib.mergeAttrs defaultConfig;
      description = "Additional environment variables to set for the Haven service. See https://github.com/bitvora/haven for documentation.";
      example = lib.literalExpression ''
        {
          PRIVATE_RELAY_NAME = "My Custom Relay Name";
          BACKUP_PROVIDER = "s3";
        }
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing sensitive environment variables. See https://github.com/bitvora/haven for documentation.
        The file should contain environment-variable assignments like:
        S3_SECRET_KEY=mysecretkey
        S3_ACCESS_KEY_ID=myaccesskey
      '';
      example = "/var/lib/haven/secrets.env";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.haven = {
      description = "Haven daemon user";
      group = "haven";
      isSystemUser = true;
    };

    users.groups.haven = { };

    systemd.services.haven = {
      description = "haven";
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.settings;

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        EnvironmentFile = cfg.environmentFile;
        User = "haven";
        Group = "haven";
        Restart = "on-failure";
        Type = "simple";

        RuntimeDirectory = "haven";
        StateDirectory = "haven";
        WorkingDirectory = "/var/lib/haven";

        # Create symlink to templates in the working directory
        ExecStartPre = "+${pkgs.coreutils}/bin/ln -sfT ${cfg.package}/share/haven/templates /var/lib/haven/templates";

        PrivateTmp = true;
        PrivateUsers = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        ProtectHostname = true;
        CapabilityBoundingSet = "";
        SystemCallFilter = [
          "@system-service"
        ];
        SystemCallArchitectures = "native";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    felixzieger
  ];
}
