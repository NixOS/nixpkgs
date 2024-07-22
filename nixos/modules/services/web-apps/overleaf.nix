{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.overleaf;

  overleafServices = [
    "chat"
    "clsi"
    "contacts"
    "docstore"
    "document-updater"
    "filestore"
    "notifications"
    "project-history"
    "real-time"
    "web"
  ] ++ (optional (cfg.dicts != [ ]) "spelling");
in

{
  meta.maintainers = with maintainers; [
    julienmalka
    camillemndn
  ];

  options.services.overleaf = {
    enable = mkEnableOption (''Overleaf'');

    hostname = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "overleaf.org";
      description = ''This enable a default nginx reverse proxy configuration.'';
    };

    redis.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''Redis is enabled by default.'';
    };

    mongodb = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''MongoDB is enabled by default.'';
      };

      package = mkOption {
        type = types.package;
        example = literalExpression "pkgs.ferretdb";
        default = pkgs.ferretdb;
        defaultText = "pkgs.ferretdb";
        description = "MongoDB/FerretDB package to use.";
      };
    };

    texlivePackage = mkOption {
      type = types.package;
      default = pkgs.texliveMedium;
      defaultText = literalExpression "pkgs.textliveMedium";
      example = literalExpression "pkgs.texliveFull";
      description = ''
        The package for TeX Live. See
        <https://search.nixos.org/packages?query=texlive>
        for available options.
      '';
    };

    settings = mkOption {
      type = types.submodule { freeformType = with types; attrsOf str; };
      default = { };
      example = {
        OVERLEAF_REDIS_HOST = "localhost";
        OVERLEAF_REDIS_PORT = "6379";
        WEB_HOST = "localhost";
        WEB_PORT = "3032";
        GRACEFUL_SHUTDOWN_DELAY = "0";
        OVERLEAF_SITE_URL = "https://overleaf.example.org";
        OVERLEAF_ADMIN_EMAIL = "overleaf@example.org";
        OVERLEAF_SITE_LANGUAGE = "fr";
        OVERLEAF_APP_NAME = "My self-hosted Overleaf instance";
        OVERLEAF_EMAIL_FROM_ADDRESS = "overleaf@example.org";
        OVERLEAF_EMAIL_SMTP_HOST = "mail.example.org";
        OVERLEAF_EMAIL_SMTP_PORT = "587";
        OVERLEAF_EMAIL_SMTP_SECURE = "true";
        OVERLEAF_EMAIL_SMTP_USER = "overleaf";
        OVERLEAF_GITBRIDGE_PORT = "3029";
        ADMIN_PRIVILEGE_AVAILABLE = "true";
      };
      description = ''
        Additional configuration for Overleaf, see
        <https://github.com/overleaf/overleaf/blob/main/server-ce/config/settings.js>
        for supported values.
      '';
    };

    secrets = mkOption {
      type = types.submodule { freeformType = with types; attrsOf str; };
      default = { };
      example = {
        WEB_API_PASSWORD = "/etc/secrets/web_api_pass";
        OVERLEAF_REDIS_PASS = "/run/secrets/overleaf_redis";
        OVERLEAF_SESSION_SECRET = "/run/secrets/overleaf_session";
        STAGING_PASSWORD_FILE = "/run/secrets/overleaf_staging";
        OVERLEAF_EMAIL_SMTP_PASS = "/run/secrets/mail/overleaf.example.org";
      };
      description = ''
        Secrets for Overleaf, see
        <https://github.com/overleaf/overleaf/blob/main/server-ce/config/settings.js>
        for supported values.
      '';
    };

    path = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression "with pkgs; [ qpdf ]";
      description = ''
        Additional packages to place in the path of the Overleaf services.
      '';
    };

    latexmkrc = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra contents appended to the LaTeX configuration file,
        .latexmkrc.
      '';
    };

    dicts = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression ''with pkgs.aspellDicts; [ en fr ]'';
      description = ''
        Additional languages to add to overleaf spell check engine,
        based on aspell.
      '';
    };

    dockerSandboxes.enable = mkEnableOption (''
      Docker sandboxed compiles, provided the user adds
        ```virtualization.docker.enable = true;```
      to their configuration. It avoids read-access to all the filesystem by any Overleaf user.
    '');
  };

  config = mkIf cfg.enable (mkMerge [
    {
      warnings = (
        optional (cfg.enable && !cfg.dockerSandboxes.enable) ''
          Enabling services.overleaf.enable but not services.overleaf.dockerSandboxes.enable is insecure because it gives read-access to the filesystem to any Overleaf user upon compilation.
        ''
      );

      services.overleaf.settings = {
        NODE_ENV = "production";
        OVERLEAF_CONFIG = "${pkgs.overleaf}/share/server-ce/config/settings.js";
        DATA_DIR = mkDefault "/var/lib/overleaf";
        OVERLEAF_MONGO_URL = mkDefault "mongodb://127.0.0.1:27017/overleaf";
        OVERLEAF_REDIS_PATH = mkDefault "/run/redis-overleaf/redis.sock";
        WEB_PORT = mkDefault "3032";
        WEB_API_USER = mkDefault "overleaf";
        GRACEFUL_SHUTDOWN_DELAY = mkDefault "0";
        OVERLEAF_FPH_DISPLAY_NEW_PROJECTS = mkDefault "true";
        SANDBOXED_COMPILES = mkIf cfg.dockerSandboxes.enable "true";
        TEX_LIVE_DOCKER_IMAGE = mkIf cfg.dockerSandboxes.enable "texlive/texlive";
      };

      systemd.targets.overleaf.requires = map (service: "overleaf-${service}.service") overleafServices;

      systemd.services =
        let
          activateServices = service: {
            "overleaf-${service}" = {
              description = "Overleaf ${service}";
              wantedBy = [
                "overleaf.target"
                "multi-user.target"
              ];
              environment = cfg.settings;
              path =
                with pkgs;
                [
                  cfg.texlivePackage
                  qpdf
                  (aspellWithDicts (ps: cfg.dicts))
                ]
                ++ cfg.path;
              serviceConfig = {
                Type = "simple";
                ExecStart = pkgs.writeShellScript "overleaf-${service}" ''
                  # This sources the secrets as environment variables, less secure but avoids a patch:
                  for secret in $(ls $CREDENTIALS_DIRECTORY)
                  do
                    export $secret=$(cat $CREDENTIALS_DIRECTORY/$secret)
                  done

                  # This softlinks the LaTeX configuration files to the home of Overleaf:
                  ${optionalString (cfg.latexmkrc != "") "ln -sf ${cfg.latexmkrc} /var/lib/overleaf/.latexmkrc"}

                  exec ${pkgs.overleaf}/bin/overleaf-${service}
                '';
                StateDirectory = "overleaf";
                WorkingDirectory = "/var/lib/overleaf";
                User = "overleaf";
                LoadCredential = mapAttrsToList (name: path: "${name}:${path}") cfg.secrets;
                SupplementaryGroups = mkIf cfg.dockerSandboxes.enable [ "docker" ];
                ProtectHome = true;
                ProtectSystem = "strict";
                NoNewPrivileges = true;
                PrivateDevices = true;
                ProtectHostname = true;
                ProtectClock = true;
                ProtectKernelTunables = true;
                ProtectKernelModules = true;
                ProtectKernelLogs = true;
                ProtectControlGroups = true;
                Restart = "on-failure";
              };
            };
          };
        in
        mkMerge (map activateServices overleafServices);

      users.users.overleaf = {
        isSystemUser = true;
        group = "overleaf";
        home = "/var/lib/overleaf";
        createHome = true;
      };

      users.groups.overleaf = { };

      services.nginx = mkIf (isString cfg.hostname) {
        enable = true;
        recommendedOptimisation = mkDefault true;
        recommendedGzipSettings = mkDefault true;

        virtualHosts."${cfg.hostname}" = {
          locations."/" = {
            proxyPass = "http://localhost:${cfg.settings.WEB_PORT}";
            proxyWebsockets = true;
          };
          locations."/socket.io" = {
            proxyPass = "http://localhost:3026";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_read_timeout 10m;
              proxy_send_timeout 10m;
            '';
          };
        };
      };

      services.redis.servers.overleaf = mkIf cfg.redis.enable {
        enable = true;
        user = "overleaf";
        port = 0;
      };
    }

    (mkIf (cfg.mongodb.enable && cfg.mongodb.package.pname == "mongodb") {
      services.mongodb = {
        enable = true;
        inherit (cfg.mongodb) package;
      };
    })

    (mkIf (cfg.mongodb.enable && cfg.mongodb.package.pname == "ferretdb") {
      services.ferretdb = {
        enable = true;
        inherit (cfg.mongodb) package;
      };
      systemd.services.ferretdb.serviceConfig.ExecStart = mkForce "${cfg.mongodb.package}/bin/ferretdb --postgresql-url=\"postgres://localhost/ferretdb?host=/run/postgresql\"";
      systemd.services.postgresql.environment.LC_ALL = "en_US.UTF-8";

      users.users.ferretdb = {
        isSystemUser = true;
        group = "ferretdb";
        home = "/var/lib/ferretdb";
        createHome = true;
      };

      users.groups.ferretdb = { };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "ferretdb" ];
        ensureUsers = [
          {
            name = "ferretdb";
            ensureDBOwnership = true;
          }
        ];
      };
    })
  ]);
}
