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
      ++ old.optional-dependencies.sql;
    makeWrapperArgs = (old.makeWrapperArgs or []) ++ [
      "--set CONFIG /etc/canaille/config.toml"
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
    # secretKeyFile = lib.mkOption {
    #   description = ''
    #     A file containing the Flask secret key. Its content is going to be provided to Canaille as `SECRET_KEY`. Make sure it has appropriate permissions. For example, copy the output of this to the specified file:
    #     ```
    #       python3 -c 'import secrets; print(secrets.token_hex())'
    #     ```
    #   '';
    #   type = lib.types.path;
    # };
    settings = mkOption {
      default = { };
      description = "Settings for Canaille. See [the documentation](https://canaille.readthedocs.io/en/latest/references/configuration.html) for details.";
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          SECRET_KEY = lib.mkOption {
            readOnly = true;
            description = "Flask Secret Key. Can't be set and must be provided through services.canaille.settings.SECRET_KEY_FILE";
            default = null;
            type = types.nullOr types.str;
          };
          SECRET_KEY_FILE = lib.mkOption {
            description = ''
              A file containing the Flask secret key. Its content is going to be provided to Canaille as `SECRET_KEY`. Make sure it has appropriate permissions. For example, copy the output of this to the specified file:
              ```
                python3 -c 'import secrets; print(secrets.token_hex())'
              ```
            '';
            type = types.path;
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
        inherit (cfg.settings) SECRET_KEY_FILE;
      };
      serviceConfig = {
        WorkingDirectory = dataDir;
        User = "canaille";
        Group = "canaille";
        StateDirectory = "canaille";
        StateDirectoryMode = "0750";
        Restart = "on-failure";
        ExecStart = let
          gunicorn = python.pkgs.gunicorn.overridePythonAttrs (old: {
            # Allows Gunicorn to set a meaningful process name
            dependencies = (old.dependencies or []) ++ old.optional-dependencies.setproctitle;
          });
        in ''
          ${gunicorn}/bin/gunicorn \
            --name=canaille \
            --bind='unix:///run/canaille.socket' \
            'canaille:create_app()'
        '';
        PrivateTmp = true;
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
}
