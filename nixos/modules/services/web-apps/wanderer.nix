{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.wanderer;

  wandererPkg = cfg.package;
  wandererDbPkg = cfg.dbPackage;
in
{

  options.services.wanderer = {
    enable = lib.mkEnableOption "Wanderer Trail Database Service";

    package = lib.mkPackageOption pkgs "wanderer" { };

    dbPackage = lib.mkPackageOption pkgs "wanderer-db" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port Wanderer HTTP server listens on.";
    };

    origin = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:8080";
      description = "Canonical origin URL for CORS and frontend redirects.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/wanderer";
      description = "State directory where PocketBase data and uploads are stored.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/wanderer.env";
      description = ''
        Environment file containing sensitive variables like `MEILI_MASTER_KEY`
        and `POCKETBASE_ENCRYPTION_KEY`.
      '';
    };

    pocketbase = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 8091;
        description = "Port PocketBase listens on.";
      };

      publicUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://127.0.0.1:8091";
        description = "URL used by client browsers to communicate with PocketBase.";
      };
    };

    meilisearch = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically enable and configure a local Meilisearch instance.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 7700;
        description = "Port local Meilisearch listens on.";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "http://127.0.0.1:7700";
        description = "URL under which Meilisearch can be reached.";
      };

      masterKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/secrets/meili_master_key";
        description = "Path to the file containing the Meilisearch master key.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.meilisearch.enable -> (cfg.meilisearch.masterKeyFile != null);
        message = "services.wanderer.meilisearch.masterKeyFile must be set when local Meilisearch is enabled.";
      }
    ];

    services.meilisearch = lib.mkIf cfg.meilisearch.enable {
      enable = true;
      listenAddress = "127.0.0.1";
      listenPort = cfg.meilisearch.port;
      masterKeyFile = cfg.meilisearch.masterKeyFile;
    };

    users.users.wanderer = {
      isSystemUser = true;
      group = "wanderer";
      home = cfg.dataDir;
    };
    users.groups.wanderer = { };

    systemd.services.wanderer-db = {
      description = "Wanderer PocketBase Backend";
      after = [ "network.target" ] ++ lib.optional cfg.meilisearch.enable "meilisearch.service";
      wants = [ "network.target" ] ++ lib.optional cfg.meilisearch.enable "meilisearch.service";
      wantedBy = [ "multi-user.target" ];

      environment = {
        MEILI_URL = cfg.meilisearch.url;
        ORIGIN = cfg.origin;
      };

      serviceConfig = {
        User = "wanderer";
        Group = "wanderer";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${wandererDbPkg}/bin/wanderer-db serve --http=127.0.0.1:${toString cfg.pocketbase.port} --dir=${cfg.dataDir}/pb_data";
        Restart = "on-failure";
        RestartSec = "5s";
        StateDirectory = "wanderer";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
      };
    };

    systemd.services.wanderer = {
      description = "Wanderer Trail Database Web Engine";
      after = [
        "network.target"
        "wanderer-db.service"
      ];
      requires = [ "wanderer-db.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        PORT = toString cfg.port;
        HOST = "127.0.0.1";
        ORIGIN = cfg.origin;
        BODY_SIZE_LIMIT = "Infinity";
        PUBLIC_POCKETBASE_URL = cfg.pocketbase.publicUrl;
        UPLOAD_FOLDER = "${cfg.dataDir}/uploads";
        MEILI_URL = cfg.meilisearch.url;
        OVERPASS_API_URL = "https://overpass-api.de";
        VALHALLA_URL = "https://valhalla1.openstreetmap.de";
        NOMINATIM_URL = "https://nominatim.openstreetmap.org";
        PUBLIC_MAP_MAX_POLYLINES = "100";
        NODE_ENV = "production";
      };

      serviceConfig = {
        User = "wanderer";
        Group = "wanderer";
        ExecStart = "${wandererPkg}/bin/wanderer";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        Restart = "on-failure";
        RestartSec = "5s";
        StateDirectory = "wanderer";
        StateDirectoryMode = "0750";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        NoNewPrivileges = true;
        CapabilityBoundingSet = "";
        RestrictRealtime = true;
        ProtectClock = true;
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ maartenbehn ];
    doc = ./wanderer.md;
  };
}
