{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.jellystat;

  defaultUser = "jellystat";
  defaultGroup = "jellystat";

  # StateDirectory= only manages paths below /var/lib.
  stateDir = lib.removePrefix "/var/lib/" cfg.dataDir;
  useStateDirectory = lib.hasPrefix "/var/lib/" cfg.dataDir;

  toEnvValue = v: if lib.isBool v then lib.boolToString v else toString v;

  secretFiles = lib.filterAttrs (_: v: v != null) cfg.secretFiles;
in
{
  options.services.jellystat = {
    enable = lib.mkEnableOption "Jellystat, a statistics app for Jellyfin";

    package = lib.mkPackageOption pkgs "jellystat" { };

    openFirewall = lib.mkEnableOption "opening the firewall for Jellystat's HTTP port";

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = ''
        User account under which Jellystat runs. The user is only created
        automatically when left at the default.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/jellystat";
      description = ''
        Persistent Jellystat state directory, holding the `backups` and `env`
        subdirectories.

        Directories below {file}`/var/lib` are managed with systemd's
        `StateDirectory=`, other locations with systemd-tmpfiles.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = defaultGroup;
      description = ''
        Group under which Jellystat runs. The group is only created
        automatically when left at the default.
      '';
    };

    database.createLocally = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to create a local PostgreSQL database for Jellystat.
        Jellystat connects to it over a Unix socket using peer
        authentication, so no password is required.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.bool
            lib.types.int
            lib.types.str
          ]
        );

        options = {
          JS_PORT = lib.mkOption {
            type = lib.types.port;
            default = 3000;
            description = "Port Jellystat listens on.";
          };

          JS_LISTEN_IP = lib.mkOption {
            type = lib.types.str;
            default = "0.0.0.0";
            description = "Address Jellystat listens on.";
          };

          POSTGRES_IP = lib.mkOption {
            type = lib.types.str;
            default = "/run/postgresql";
            description = ''
              PostgreSQL host, or the directory containing its Unix socket.
            '';
          };

          POSTGRES_PORT = lib.mkOption {
            type = lib.types.port;
            default = config.services.postgresql.settings.port;
            defaultText = lib.literalExpression "config.services.postgresql.settings.port";
            description = "PostgreSQL port.";
          };

          POSTGRES_USER = lib.mkOption {
            type = lib.types.str;
            default = cfg.user;
            defaultText = lib.literalExpression "config.services.jellystat.user";
            description = "PostgreSQL user.";
          };

          POSTGRES_DB = lib.mkOption {
            type = lib.types.str;
            default = cfg.settings.POSTGRES_USER;
            defaultText = lib.literalExpression "config.services.jellystat.settings.POSTGRES_USER";
            description = "PostgreSQL database name.";
          };
        };
      };
      default = { };
      example = {
        TZ = "Australia/Brisbane";
        JS_BASE_URL = "/jellystat";
        POSTGRES_SSL_ENABLED = true;
      };
      description = ''
        Environment variables passed to Jellystat. See the
        [upstream documentation](https://github.com/CyferShepard/Jellystat#environmental-variables)
        for the available variables. Secrets belong in
        {option}`services.jellystat.secretFiles` instead.
      '';
    };

    secretFiles = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.path;

        options = {
          JWT_SECRET = lib.mkOption {
            type = lib.types.path;
            description = "Path to a file containing the JWT signing secret.";
          };

          POSTGRES_PASSWORD = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = ''
              Path to a file containing the PostgreSQL password. Not needed when
              {option}`services.jellystat.database.createLocally` is enabled.
            '';
          };
        };
      };
      example = lib.literalExpression ''
        {
          JWT_SECRET = "/run/secrets/jellystat-jwt";
          JS_GEOLITE_LICENSE_KEY = "/run/secrets/geolite-key";
        }
      '';
      description = ''
        Files whose contents are exported as environment variables, keyed by
        variable name. They are passed to the service with systemd
        `LoadCredential=` and never copied into the Nix store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.database.createLocally
          -> cfg.settings.POSTGRES_USER == cfg.user && cfg.settings.POSTGRES_DB == cfg.settings.POSTGRES_USER;
        message = ''
          services.jellystat.database.createLocally uses peer authentication, so
          settings.POSTGRES_USER and settings.POSTGRES_DB must both equal services.jellystat.user.
        '';
      }
      {
        assertion = !cfg.database.createLocally -> cfg.secretFiles.POSTGRES_PASSWORD != null;
        message = ''
          services.jellystat.secretFiles.POSTGRES_PASSWORD must be set when
          services.jellystat.database.createLocally is disabled.
        '';
      }
    ];

    services.jellystat.settings = lib.mapAttrs (_: lib.mkDefault) {
      JS_BACKUP_DIR = "${cfg.dataDir}/backups";
      JS_ENV_DIR = "${cfg.dataDir}/env";
    };

    users = {
      users = lib.mkIf (cfg.user == defaultUser) {
        ${defaultUser} = {
          description = "Jellystat service user";
          inherit (cfg) group;
          isSystemUser = true;
        };
      };
      groups = lib.mkIf (cfg.group == defaultGroup) { ${defaultGroup} = { }; };
    };

    systemd.tmpfiles.settings."10-jellystat" = lib.mkIf (!useStateDirectory) (
      lib.genAttrs
        [
          cfg.dataDir
          "${cfg.dataDir}/backups"
          "${cfg.dataDir}/env"
        ]
        (_: {
          d = {
            inherit (cfg) user group;
            mode = ":0750";
          };
        })
    );

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.JS_PORT ];

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.settings.POSTGRES_DB ];
      ensureUsers = [
        {
          name = cfg.settings.POSTGRES_USER;
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.jellystat = {
      description = "Jellystat service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ] ++ lib.optional cfg.database.createLocally "postgresql.target";
      requires = lib.optional cfg.database.createLocally "postgresql.target";
      wants = [ "network-online.target" ];

      # Jellystat refuses to start when POSTGRES_PASSWORD is undefined, even
      # though peer authentication does not use it.
      environment =
        lib.optionalAttrs (cfg.secretFiles.POSTGRES_PASSWORD == null) { POSTGRES_PASSWORD = ""; }
        // lib.mapAttrs (_: toEnvValue) cfg.settings;

      script = ''
        ${lib.concatMapStrings (name: ''
          export ${name}="$(< "$CREDENTIALS_DIRECTORY/${name}")"
        '') (lib.attrNames secretFiles)}
        exec ${lib.getExe cfg.package}
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "${cfg.package}/share/jellystat/backend";
        LoadCredential = lib.mapAttrsToList (name: file: "${name}:${file}") secretFiles;
        StateDirectory = lib.mkIf useStateDirectory [
          stateDir
          "${stateDir}/backups"
          "${stateDir}/env"
        ];
        StateDirectoryMode = ":0750";
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ mistyttm ];
    doc = ./jellystat.md;
  };
}
