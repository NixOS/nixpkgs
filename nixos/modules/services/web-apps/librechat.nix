{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.librechat;
  meiliCfg = config.services.meilisearch;
  format = pkgs.formats.yaml { };
  configFile = format.generate "librechat.yaml" cfg.settings;
  exportCredentials = n: _: ''export ${n}="$(${pkgs.systemd}/bin/systemd-creds cat ${n}_FILE)"'';
  exportAllCredentials = vars: lib.concatStringsSep "\n" (lib.mapAttrsToList exportCredentials vars);
  getLoadCredentialList = lib.mapAttrsToList (n: v: "${n}_FILE:${v}") cfg.credentials;
in
{
  options.services.librechat = {
    enable = lib.mkEnableOption "the LibreChat server";

    package = lib.mkPackageOption pkgs "librechat" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the port in the firewall.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/librechat";
      example = "/persist/librechat";
      description = "Absolute path for where the LibreChat server will use as its data directory to store logs, user uploads, and generated images.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "librechat";
      example = "alice";
      description = "The user to run the service as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "librechat";
      example = "users";
      description = "The group to run the service as.";
    };

    credentials = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      example = {
        CREDS_KEY = "/run/secrets/creds_key";
      };
      description = ''
        Environment variables which are loaded from the contents of files at a file paths, mainly used for secrets.
        See [LibreChat environment variables](https://www.librechat.ai/docs/configuration/dotenv).
        Alternatively you can use `services.librechat.credentialsFile` to define all the variables in a single file.
      '';
    };

    env = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            str
            path
            (coercedTo int toString str)
            (coercedTo float toString str)
            (coercedTo port toString str)
            (coercedTo bool (x: if x then "true" else "false") str)
          ]);
        options = {
          CONFIG_PATH = lib.mkOption {
            default = configFile;
            internal = true;
            readOnly = true;
          };
          PORT = lib.mkOption {
            type = with lib.types; coercedTo port toString str;
            default = 3080;
            example = 2309;
            description = "The value that will be passed to the PORT environment variable, telling LibreChat what to listen on.";
          };
        };
      };
      example = {
        ALLOW_REGISTRATION = true;
        HOST = "0.0.0.0";
        PORT = 2309;
        CONSOLE_JSON_STRING_LENGTH = 255;
      };
      description = ''
        Environment variables that will be set for the service.
        See [LibreChat environment variables](https://www.librechat.ai/docs/configuration/dotenv).
      '';
    };

    credentialsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to a file that contains environment variables.
        See [LibreChat environment variables](https://www.librechat.ai/docs/configuration/dotenv).

        Example content of the file:
        ```
        CREDS_KEY=6d6deb03cdfb27ea454f6b9ddd42494bdce4af25d50d8aee454ddce583690cc5
        ```

        Alternatively you can use `services.librechat.credentials` to define the value of each variable in a separate file.
      '';
      default = "/dev/null";
      example = "/run/secrets/librechat";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
      example = {
        version = "1.0.8";
        cache = true;
        interface = {
          privacyPolicy = {
            externalUrl = "https://librechat.ai/privacy-policy";
            openNewTab = true;
          };
        };
        endpoints = {
          custom = [
            {
              name = "OpenRouter";
              apiKey = "\${OPENROUTER_KEY}";
              baseURL = "https://openrouter.ai/api/v1";
              models = {
                default = [ "meta-llama/llama-3-70b-instruct" ];
                fetch = true;
              };
              titleConvo = true;
              titleModule = "meta-llama/llama-3-70b-instruct";
              dropParams = [ "stop" ];
              modelDisplayLabel = "OpenRouter";
            }
          ];
        };
      };
      description = ''
        A free-form attribute set that will be written to librechat.yaml.
        See the [LibreChat configuration options](https://www.librechat.ai/docs/configuration/librechat_yaml).
        You can use environment variables by wrapping them in $\{}. Take care to escape the \$ character.
      '';
    };

    enableLocalDB = lib.mkEnableOption "a local mongodb instance";

    meilisearch = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = ''
              Whether to enable and configure Meilisearch locally for Librechat.
              You will manually need to set `services.meilisearch.masterKeyFile`.
            '';
          };
        };
      };
      default = { };
      description = ''
        See [LibreChat search feature](https://www.librechat.ai/docs/features/search).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.env ? MONGO_URI || cfg.credentials ? MONGO_URI;
        message = "MongoDB is not configured, either set `services.librechat.enableLocalDB = true` or provide your own MongoDB instance by setting `services.librechat.env.MONGO_URI` or `services.credentials.MONGO_URI`.";
      }
      {
        assertion =
          cfg.credentialsFile != "/dev/null"
          || (
            (cfg.env ? CREDS_KEY || cfg.credentials ? CREDS_KEY)
            && (cfg.env ? CREDS_IV || cfg.credentials ? CREDS_IV)
            && (cfg.env ? JWT_SECRET || cfg.credentials ? JWT_SECRET)
            && (cfg.env ? JWT_REFRESH_SECRET || cfg.credentials ? JWT_REFRESH_SECRET)
          );
        message = ''
          CREDS_KEY, CREDS_IV, JWT_SECRET, and JWT_REFRESH_SECRET must be defined in `services.librechat.credentials` and point to locations of files on the host or in a file that `services.credentialsFile` is pointing to.
          Alternatively it can be defined in `services.librechat.env` with literal values but they will be saved within the world-readable nix store.;
          You can use https://www.librechat.ai/toolkit/creds_generator to generate these.
        '';
      }
      {
        assertion = cfg.meilisearch.enable -> meiliCfg.masterKeyFile != null;
        message = ''
          LibreChat's Meilisearch integration requires `services.meilisearch.masterKeyFile` to be set.
        '';
      }
    ];

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

    systemd.tmpfiles.settings."10-librechat"."${cfg.dataDir}".d = {
      mode = "0755";
      inherit (cfg) user group;
    };

    systemd.services.librechat = {
      wantedBy = [ "multi-user.target" ];
      after = [
        "tmpfiles.target"
      ]
      ++ lib.optional cfg.meilisearch.enable "meilisearch.service";
      wants = lib.optional cfg.meilisearch.enable "meilisearch.service";
      description = "Open-source app for all your AI conversations, fully customizable and compatible with any AI provider";
      environment = cfg.env;
      script = # sh
        ''
          ${exportAllCredentials cfg.credentials}
          cd ${cfg.dataDir}
          ${lib.getExe cfg.package}
        '';
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = baseNameOf cfg.dataDir;
        WorkingDirectory = cfg.dataDir;
        LoadCredential = getLoadCredentialList;
        EnvironmentFile = cfg.credentialsFile;
        Restart = "on-failure";
        RestartSec = 10;

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        UMask = "0077";
      };
    };

    users.users.librechat = lib.mkIf (cfg.user == "librechat") {
      name = "librechat";
      isSystemUser = true;
      group = "librechat";
      description = "LibreChat server user";
    };

    users.groups.librechat = lib.mkIf (cfg.user == "librechat") { };

    services.librechat.env.MONGO_URI = lib.mkIf cfg.enableLocalDB "mongodb://localhost:27017";
    services.mongodb.enable = lib.mkIf cfg.enableLocalDB true;

    services.meilisearch.enable = lib.mkIf cfg.meilisearch.enable true;
    services.librechat.env.SEARCH = lib.mkIf cfg.meilisearch.enable true;
    services.librechat.env.MEILI_HOST = lib.mkIf cfg.meilisearch.enable "http://${meiliCfg.settings.http_addr}";
    services.librechat.credentials.MEILI_MASTER_KEY = lib.mkIf cfg.meilisearch.enable meiliCfg.masterKeyFile;
  };

  meta.maintainers = with lib.maintainers; [
    gepbird
    niklaskorz
    rrvsh
  ];
}
