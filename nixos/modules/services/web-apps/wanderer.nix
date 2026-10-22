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
    getExe'
    mapAttrs
    filterAttrs
    mapAttrsToList
    literalExpression
    optional
    optionals
    ;

  stateDir = "/var/lib/wanderer";

  pluginDir = pkgs.symlinkJoin {
    name = "wanderer-plugins";
    paths = cfg.plugins;
  };

  environment = mapAttrs (_: v: if lib.isBool v then lib.boolToString v else toString v) (
    filterAttrs (_: v: v != null) cfg.settings
  );

  webPackage =
    if cfg.about == null then
      cfg.package.web
    else
      cfg.package.web.override {
        aboutFile = if types.path.check cfg.about then cfg.about else pkgs.writeText "about.md" cfg.about;
      };

  secrets = filterAttrs (_: v: v != null) cfg.secrets;
  webSecrets = filterAttrs (n: _: n == "POCKETBASE_PROXY_SECRET") secrets;

  # wanderer only reads secrets from environment variables, so export each credential loaded through `LoadCredential`
  exportSecrets =
    secrets:
    lib.concatMapStrings (name: ''
      export ${name}="$(< "$CREDENTIALS_DIRECTORY/${name}")"
    '') (lib.attrNames secrets);

  serviceDefaults = {
    Type = "simple";
    DynamicUser = true;
    User = "wanderer";
    Group = "wanderer";
    Restart = "on-failure";
    RestartSec = "5s";

    CapabilityBoundingSet = "";
    DevicePolicy = "closed";
    LockPersonality = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProcSubset = "pid";
    ProtectClock = true;
    ProtectControlGroups = true;
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
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
    ];
    UMask = "0077";
  };
in
{
  options.services.wanderer = {
    enable = mkEnableOption "wanderer, a self-hosted trail database";

    package = mkPackageOption pkgs "wanderer" { };

    plugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "with pkgs.wanderer.plugins; [ komoot strava ]";
      description = ''
        Plugins to install.
        The first-party plugins are available in `pkgs.wanderer.plugins`.
      '';
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "Address on which the wanderer web frontend listens.";
    };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = "Port on which the wanderer web frontend listens.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open {option}`services.wanderer.port` in the firewall.";
    };

    pocketbase = {
      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address on which the wanderer PocketBase backend listens.";
      };

      port = mkOption {
        type = types.port;
        default = 8090;
        description = "Port on which the wanderer PocketBase backend listens.";
      };
    };

    about = mkOption {
      type = with types; nullOr (either path str);
      default = null;
      example = literalExpression "./about.md";
      description = ''
        Markdown shown in the "About" section to visitors who are not logged in.
        Note that changing this rebuilds the web frontend!
      '';
    };

    meilisearch.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable a local meilisearch instance through {option}`services.meilisearch`.
        If disabled, point {option}`services.wanderer.settings.MEILI_URL` at an existing instance.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType =
          with types;
          attrsOf (
            nullOr (oneOf [
              bool
              int
              str
            ])
          );

        options = {
          ORIGIN = mkOption {
            type = types.str;
            example = "https://wanderer.example.com";
            description = ''
              Scheme and address via which the wanderer frontend is reachable.
              This must match what users enter into their browser's address bar *exactly*,
              otherwise wanderer shows a warning about mismatched hosts on every page.
              This also applies when running behind a reverse proxy.
            '';
          };

          MEILI_URL = mkOption {
            type = types.str;
            default = "http://${config.services.meilisearch.listenAddress}:${toString config.services.meilisearch.listenPort}";
            defaultText = literalExpression ''"http://''${config.services.meilisearch.listenAddress}:''${toString config.services.meilisearch.listenPort}"'';
            description = "URL of the meilisearch instance, including scheme and port.";
          };

          PUBLIC_POCKETBASE_URL = mkOption {
            type = types.str;
            default = "http://${cfg.pocketbase.host}:${toString cfg.pocketbase.port}";
            defaultText = literalExpression ''"http://''${config.services.wanderer.pocketbase.host}:''${toString config.services.wanderer.pocketbase.port}"'';
            description = "URL under which the frontend reaches the PocketBase backend.";
          };

          PUBLIC_DISABLE_SIGNUP = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to disable signups of new users.";
          };

          PUBLIC_PRIVATE_INSTANCE = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to block visitors without an account from viewing any content.";
          };

          BODY_SIZE_LIMIT = mkOption {
            type = types.str;
            default = "Infinity";
            example = "512M";
            description = ''
              Maximum allowed request body size, and therefore upload size, in bytes.
              The suffixes `K`, `M` and `G` are accepted, `Infinity` disables the limit.
            '';
          };
        };
      };
      default = { };
      example = {
        ORIGIN = "https://wanderer.example.com";
        PUBLIC_DISABLE_SIGNUP = true;
        POCKETBASE_SMTP_ENABLED = true;
        POCKETBASE_SMTP_SENDER_NAME = "wanderer";
      };
      description = ''
        Environment variables passed to the wanderer backend and frontend.
        See [the wanderer documentation](https://wanderer.to/run/environment-configuration/) for available options.
        Secrets must be set using {option}`services.wanderer.secrets` instead.
      '';
    };

    secrets = mkOption {
      type = types.submodule {
        freeformType = with types; attrsOf (nullOr path);

        options = {
          MEILI_MASTER_KEY = mkOption {
            type = with types; nullOr path;
            default = if cfg.meilisearch.enable then config.services.meilisearch.masterKeyFile else null;
            defaultText = literalExpression "if config.services.wanderer.meilisearch.enable then config.services.meilisearch.masterKeyFile else null";
            description = "File containing the meilisearch master key.";
          };

          POCKETBASE_ENCRYPTION_KEY = mkOption {
            type = with types; nullOr path;
            default = null;
            example = "/run/secrets/wanderer-encryption-key";
            description = ''
              File containing the key used to encrypt secrets in the database.
              Must be exactly 32 characters long, for example generated with `openssl rand -hex 16`.
            '';
          };

          POCKETBASE_PROXY_SECRET = mkOption {
            type = with types; nullOr path;
            default = null;
            example = "/run/secrets/wanderer-proxy-secret";
            description = ''
              File containing the secret authenticating the frontend to the backend, for example generated with `openssl rand -hex 32`.
            '';
          };
        };
      };
      default = { };
      example = {
        POCKETBASE_ENCRYPTION_KEY = "/run/secrets/wanderer-encryption-key";
        POCKETBASE_PROXY_SECRET = "/run/secrets/wanderer-proxy-secret";
        POCKETBASE_SMTP_PASSWORD = "/run/secrets/wanderer-smtp-password";
      };
      description = ''
        Files containing secrets, passed to the backend as environment variables named after the attribute.
        {env}`POCKETBASE_PROXY_SECRET` is passed to the frontend as well.
        The files are loaded with systemd's `LoadCredential` and need not be readable by the service user.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions =
      map
        (name: {
          assertion = cfg.secrets.${name} != null;
          message = "services.wanderer.secrets.${name} must be set.";
        })
        [
          "MEILI_MASTER_KEY"
          "POCKETBASE_ENCRYPTION_KEY"
          "POCKETBASE_PROXY_SECRET"
        ];

    services.meilisearch.enable = mkIf cfg.meilisearch.enable (lib.mkDefault true);

    systemd.services.wanderer = {
      description = "wanderer PocketBase backend";
      wants = optional cfg.meilisearch.enable "meilisearch.service";
      after = [ "network.target" ] ++ optional cfg.meilisearch.enable "meilisearch.service";
      wantedBy = [ "multi-user.target" ];

      inherit environment;

      script = ''
        ${exportSecrets secrets}
        exec ${
          lib.escapeShellArgs [
            (getExe cfg.package)
            "serve"
            "--dir=${stateDir}"
            "--http=${cfg.pocketbase.host}:${toString cfg.pocketbase.port}"
          ]
        }
      '';

      serviceConfig = serviceDefaults // {
        StateDirectory = [
          "wanderer"
          "wanderer/migrations/initial_data"
        ]
        ++ optional (cfg.plugins != [ ]) "wanderer/data/plugins";
        WorkingDirectory = stateDir;
        BindReadOnlyPaths = [
          "${cfg.package}/share/wanderer/initial_data:${stateDir}/migrations/initial_data"
        ]
        ++ optional (cfg.plugins != [ ]) "${pluginDir}:${stateDir}/data/plugins";
        LoadCredential = mapAttrsToList (name: path: "${name}:${path}") secrets;
      };
    };

    systemd.services.wanderer-web = {
      description = "wanderer web frontend";
      bindsTo = [ "wanderer.service" ];
      after = [ "wanderer.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = environment // {
        HOST = cfg.host;
        PORT = toString cfg.port;
      };

      script = ''
        ${exportSecrets webSecrets}
        exec ${getExe' webPackage "wanderer-web"}
      '';

      serviceConfig = serviceDefaults // {
        LoadCredential = mapAttrsToList (name: path: "${name}:${path}") webSecrets;
      };
    };

    networking.firewall.allowedTCPPorts = optionals cfg.openFirewall [ cfg.port ];
  };

  meta = {
    doc = ./wanderer.md;
    maintainers = with lib.maintainers; [
      charludo
      maartenbehn
    ];
  };
}
