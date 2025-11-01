{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.wanderer;
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    getExe
    mapAttrs
    boolToString
    ;

  stateDir = "/var/lib/wanderer";
  user = "wanderer";
  group = "wanderer";
in
{
  options = {
    services.wanderer = {
      enable = mkEnableOption "wanderer";

      origin = mkOption {
        type = types.str;
        default = "http://localhost";
        description = ''
          Scheme + address via which the wanderer frontend will be reachable.
          This must match what users input into their browser's address bar *exactly*, otherwise wanderer shows a nasty warning on every page.
          Set to `http://localhost` if you wish to use wanderer only from the same host it is running on, otherwise to a FQDN incl. scheme,
          for example: `https://wanderer.example.com`.

          Even if wanderer is running behind a reverse proxy like NGINX, you will get the warning about mismatched hosts unless you follow the advice above.
          Note that setting this to an IP, incl. `http://127.0.0.1` and `http://0.0.0.0`, will cause wanderer to panic.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 3000;
        description = "Port on which the wanderer web interface is served";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the wanderer web interface";
      };

      services = {
        valhalla.url = mkOption {
          type = types.str;
          default = "https://valhalla1.openstreetmap.de";
          description = "Public IP or address (including the port) of a valhalla instance";
        };

        nominatim.url = mkOption {
          type = types.str;
          default = "https://nominatim.openstreetmap.org";
          description = "Public IP or address (including the port) of a nominatim instance";
        };

        pocketbase.url = mkOption {
          type = types.str;
          default = "http://127.0.0.1:8090";
          description = "Public IP or address of the wanderer pocketbase instance, incl. port and schema";
        };

        meilisearch = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "wanderer requires a meilisearch instance. By default, one is started. If set to `false`, you need to manually configure an instance.";
          };

          url = mkOption {
            type = types.str;
            default = "http://127.0.0.1:7700";
            description = "IP or address on which meilisearch is available, incl. schema and port";
          };
        };
      };

      settings = {
        about = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Set a custom text for the "About" section of the home page. Full markdown is supported.
            If the value is `null`, the [default "About" section](https://wanderer.to/run/frontend-configuration/about) is used:

            ```
            Welcome to wanderer, a self-hosted service for managing and sharing your outdoor adventures.

            With wanderer you can:
            - Upload and store your GPS tracks (GPX files)
            - Organize routes with descriptions, waypoints, photos, and tags
            - Search and filter through your personal trail library
            - Optionally connect with other wanderer instances via ActivityPub to share tracks across the Fediverse
            - And much more

            wanderer is designed for explorers who value privacy, control, and open technology.
            ```
          '';
        };

        syncSchedule = mkOption {
          type = types.str;
          default = "0 2 * * *";
          description = "Valid cron expression. Sets how often trails are synced from 3rd party integrations";
        };

        bodySizeLimit = mkOption {
          type = types.str;
          default = "Infinity";
          description = "Maximum allowed upload size";
        };

        disableSignup = mkOption {
          type = types.bool;
          default = false;
          description = "Disables signup option for new users";
        };

        privateInstance = mkOption {
          type = types.bool;
          default = false;
          description = "Setting this to true will block visitors from viewing content without an account";
        };

        uploadDir = mkOption {
          type = types.path;
          default = "${stateDir}/upload";
          description = "Folder from which wanderer auto-uploads trails";
        };
      };

      extraConfig = mkOption {
        type =
          with types;
          attrsOf (
            nullOr (oneOf [
              bool
              int
              str
            ])
          );
        default = { };
        example = {
          POCKETBASE_SMTP_SENDER_NAME = "MyWandererInstance";
        };
        description = ''
          The configuration of wanderer is handled through environment variables.
          The available configuration options can be found in [the wanderer docs](https://wanderer.to/run/environment-configuration/).
        '';
      };

      secretsFile = mkOption {
        type = types.path;
        example = "/run/secrets/wanderer";
        description = ''
          Secrets like {env}`MEILI_MASTER_KEY` and {env}`POCKETBASE_ENCRYPTION_KEY`
          must be passed to the service without adding them to the world-readable Nix store.

          This file needs to be available on the host on which `wanderer` is running.
          {env}`POCKETBASE_ENCRYPTION_KEY` must be exactly 32 characters long.
          One way to generate such a secret is to use `openssl rand -hex 16`.

          At a **minimum**, the contents of the file must look like this:
          ```
          MEILI_MASTER_KEY=...master key used by the wanderer backend and frontend, and by meilisearch...
          POCKETBASE_ENCRYPTION_KEY=...encryption key used by the wanderer backend, exactly 32 chars long...
          ```
        '';
      };

      package = mkPackageOption pkgs "wanderer" { };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.wanderer = {
      description = "wanderer pocketbase db";
      after = [
        "network.target"
        "meilisearch.service"
      ];
      wantedBy = [ "wanderer-web.service" ];

      environment = {
        ORIGIN = cfg.origin;
        MEILI_URL = cfg.services.meilisearch.url;
        POCKETBASE_CRON_SYNC_SCHEDULE = cfg.settings.syncSchedule;
      }
      // (mapAttrs (_: toString) cfg.extraConfig);

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        User = user;
        Group = group;

        StateDirectory = baseNameOf stateDir;
        BindPaths = [
          "${cfg.package}/share/initial_data:${stateDir}/migrations/initial_data"
        ];
        WorkingDirectory = stateDir;

        EnvironmentFile = cfg.secretsFile;

        ExecStart =
          let
            url = cfg.services.pocketbase.url;
            scheme =
              if lib.hasPrefix "https://" url then
                "https"
              else if lib.hasPrefix "http://" url then
                "http"
              else
                throw "pocketbase url must start with http:// or https://";
            host = lib.removePrefix "${scheme}://" url;
          in
          "${getExe cfg.package} serve --dir=\"${stateDir}\" --${scheme}=\"${host}\"";
        Restart = "on-failure";
      };
    };

    systemd.services.wanderer-web = {
      description = "wanderer web app";
      bindsTo = [ "wanderer.service" ];
      after = [
        "wanderer.service"
        "meilisearch.service"
      ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        ORIGIN = cfg.origin;
        PORT = toString cfg.port;
        MEILI_URL = cfg.services.meilisearch.url;
        BODY_SIZE_LIMIT = cfg.settings.bodySizeLimit;
        UPLOAD_FOLDER = cfg.settings.uploadDir;
        PUBLIC_DISABLE_SIGNUP = boolToString cfg.settings.disableSignup;
        PUBLIC_PRIVATE_INSTANCE = boolToString cfg.settings.privateInstance;
        PUBLIC_POCKETBASE_URL = cfg.services.pocketbase.url;
        PUBLIC_VALHALLA_URL = cfg.services.valhalla.url;
        PUBLIC_NOMINATIM_URL = cfg.services.nominatim.url;
      }
      // (mapAttrs (_: toString) cfg.extraConfig);

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        User = user;
        Group = group;

        StateDirectory = baseNameOf stateDir;
        BindReadOnlyPaths = [
          "${cfg.package}/share/web:${stateDir}/web"
        ]
        ++
          lib.optional (cfg.settings.about != null)
            "${pkgs.writeText "wanderer-about.md" cfg.settings.about}:${stateDir}/web/build/client/md/about.md";
        WorkingDirectory = stateDir;

        EnvironmentFile = cfg.secretsFile;

        ExecStart = "${pkgs.nodejs}/bin/node ${stateDir}/web/build/index.js";
        Restart = "on-failure";
      };
    };

    services.meilisearch = mkIf cfg.services.meilisearch.enable {
      enable = true;
    };
    systemd.services.meilisearch = mkIf cfg.services.meilisearch.enable {
      wantedBy = [
        "wanderer.service"
        "wanderer-web.service"
      ];
      serviceConfig = {
        Environment = [ "MEILI_URL=${cfg.services.meilisearch.url}" ];
        EnvironmentFile = cfg.secretsFile;
      };
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
  };
}
