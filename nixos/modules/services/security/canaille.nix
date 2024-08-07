{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.canaille;

  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    types
    getExe
    ;

  dataDir = "/var/lib/canaille";
  secretsDir = "${dataDir}/secrets";

  settingsFormat = pkgs.formats.toml { };

  # Remove null values, so we can document optional/forbidden values that don't end up in the generated TOML file.
  filterConfig = lib.converge (lib.filterAttrsRecursive (_: v: v != null));

  finalPackage = cfg.package.overridePythonAttrs (old: {
    dependencies =
      old.dependencies
      ++ old.optional-dependencies.front
      ++ old.optional-dependencies.oidc
      ++ old.optional-dependencies.ldap
      ++ old.optional-dependencies.sentry
      ++ old.optional-dependencies.sql
      ++ old.optional-dependencies.postgresql;
    makeWrapperArgs = (old.makeWrapperArgs or []) ++ [
      "--set CONFIG /etc/canaille/config.toml"
      "--set SECRETS_DIR \"${secretsDir}\""
    ];
  });
  inherit (finalPackage) python;
  pythonEnv = python.buildEnv.override {
    extraLibs = with python.pkgs; [
      (toPythonModule finalPackage)
      celery
    ];
  };
in
{

  options.services.canaille = {
    enable = mkEnableOption "Canaille";
    package = mkPackageOption pkgs "canaille" { };
    secretKeyFile = lib.mkOption {
      description = ''
        A file containing the Flask secret key. Its content is going to be provided to Canaille as `SECRET_KEY`. Make sure it has appropriate permissions. For example, copy the output of this to the specified file:
        ```
          python3 -c 'import secrets; print(secrets.token_hex())'
        ```
      '';
      type = lib.types.path;
    };
    settings = mkOption {
      default = { };
      description = "Settings for Canaille. See [the documentation](https://canaille.readthedocs.io/en/latest/references/configuration.html) for details.";
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          SECRET_KEY = lib.mkOption {
            readOnly = true;
            description = "Flask Secret Key. Can't be set and must be provided through services.canaille.settings.secretKeyFile";
            default = null;
            type = types.nullOr types.str;
          };
          SERVER_NAME = lib.mkOption {
            description = "The domain name on which canaille will be served.";
            example = "auth.example.org";
            type = types.str;
          };
          PREFERRED_URL_SCHEME = lib.mkOption {
            description = "The url scheme by which canaille will be served.";
            default = "https";
            type = types.enum [
              "http"
              "https"
            ];
          };

          CANAILLE = {
            ACL = { };
            SMTP = { };
          };
          CANAILLE_SQL = {
            DATABASE_URI = lib.mkOption {
              description = "The SQL server URI. Will configure a local PostgreSQL db if left to default. Please note that the NixOS module only supports PostgreSQL for now.";
              default = "postgresql://localhost/canaille?host=/run/postgresql";
              type = types.str;
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."canaille/config.toml" = {
      source = settingsFormat.generate "config.toml" (filterConfig cfg.settings);
      user = "canaille";
      group = "canaille";
    };

    # Secrets management is unfortunately done in a semi stateful way, due to these constraints:
    # - Canaille uses Pydantic, which currently only accepts an env file or a single
    #   directory (SECRETS_DIR) for loading settings from files.
    # - The canaille user needs access to secrets, as it needs to run the CLI
    #   for e.g. user creation. Therefore specifying the SECRETS_DIR as systemds
    #   CREDENTIALS_DIRECTORY is not an option.
    systemd.tmpfiles.rules = [
      "Z  ${secretsDir} 700 canaille canaille - -"
      "L+ ${secretsDir}/SECRET_KEY - - - - ${cfg.secretKeyFile}"
    ];

    systemd.services.canaille = {
      description = "Canaille";
      documentation = [ "https://canaille.readthedocs.io/en/latest/tutorial/deployment.html" ];
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "postgresql.target"
      ];
      requires = [ "postgresql.service" "canaille.socket" ];
      environment = {
        PYTHONPATH = "${pythonEnv}/${python.sitePackages}/";
        CONFIG = "/etc/canaille/config.toml";
        SECRETS_DIR = secretsDir;
      };
      restartTriggers = [ "/etc/canaille/config.toml" ];
      serviceConfig = {
        WorkingDirectory = dataDir;
        User = "canaille";
        Group = "canaille";
        StateDirectory = "canaille";
        StateDirectoryMode = "0750";
        Restart = "on-failure";
        PrivateTmp = true;
        ExecStart= let
          gunicorn = python.pkgs.gunicorn.overridePythonAttrs (old: {
            # Allows Gunicorn to set a meaningful process name
            dependencies = (old.dependencies or []) ++ old.optional-dependencies.setproctitle;
          });
        in ''
          ${gunicorn}/bin/gunicorn \
            --name=canaille \
            --bind='unix:///run/canaille.socket' \
            --log-level debug \
            --workers=2 \
            'canaille:create_app()'
        '';
      };
    };

    systemd.sockets.canaille = {
      before = [ "nginx.service" ];
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "/run/canaille.socket";
        SocketUser = "canaille";
        SocketGroup = "canaille";
        SocketMode = "770";
      };
    };

    services.nginx.enable = true;
    services.nginx.recommendedGzipSettings = true;
    services.nginx.virtualHosts."${cfg.settings.SERVER_NAME}" = {
      forceSSL = true;
      enableACME = true;
      # Config from https://canaille.readthedocs.io/en/latest/tutorial/deployment.html#nginx
      extraConfig = ''
        charset utf-8;
        client_max_body_size 10M;

        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
        add_header X-Frame-Options                      "SAMEORIGIN"    always;
        add_header X-XSS-Protection                     "1; mode=block" always;
        add_header X-Content-Type-Options               "nosniff"       always;
        add_header Referrer-Policy                      "same-origin"   always;
      '';
      locations = {
        "/".proxyPass = "http://unix:///run/canaille.socket";
        "/static" = {
          root = "${finalPackage}/${python.sitePackages}/canaille/static";
        };
        "~* ^/static/.+\\.(?:css|cur|js|jpe?g|gif|htc|ico|png|html|xml|otf|ttf|eot|woff|woff2|svg)$".extraConfig = ''
          access_log off;
          expires 30d;
          more_set_headers Cache-Control public;
        '';
      };
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "canaille";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "canaille" ];
    };

    users.users.canaille = {
      isSystemUser = true;
      group = "canaille";
      packages = [ finalPackage ];
    };

    users.groups.canaille.members = [ config.services.nginx.user ];
  };

  meta.maintainers = with lib.maintainers; [ erictapen ];
}
