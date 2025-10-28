{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.authentik;

  after = [ "network-online.target" ] ++ lib.optional cfg.database.createLocally "postgresql.service";

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    ;

  secretsFor =
    path: secretFiles:
    secretFiles // (lib.attrsets.attrByPath path { secretFiles = { }; } cfg).secretFiles;

  credentialsEnv =
    path: secretFiles: lib.mapAttrs (name: file: "file:%d/${name}") (secretsFor path secretFiles);

  credentials =
    path: secretFiles: lib.mapAttrsToList (name: file: "${name}:${file}") (secretsFor path secretFiles);

  commonServiceConfig = {
    Type = "simple";
    Restart = "always";
    RestartSec = 3;
    NoNewPrivileges = true;
    PrivateTmp = true;
    ProtectHome = true;
    ProtectSystem = "full";
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    SystemCallFilter = "~@cpu-emulation @keyring @module @obsolete @raw-io @reboot @swap @sync";
    ConfigurationDirectory = "authentik";
  };

  secret = types.nullOr (
    types.str
    // {
      # We don't want users to be able to pass a path literal here but
      # it should look like a path.
      check = it: lib.isString it && lib.types.path.check it;
    }
  );

  mkEnvOptions = name: global: {
    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        AUTHENTIK_LISTEN__METRICS = "localhost:9300";
      };
      description = ''
        Extra configuration environment variables for the authentik ${name}.${lib.optionalString global " These overwrite the global environment variables."}
        Refer to the [documentation](https://docs.goauthentik.io/install-config/configuration) for options.
      '';
    };

    secretFiles = mkOption {
      type = types.attrsOf secret;
      example = {
        AUTHENTIK_POSTGRESQL__PASSWORD = "/run/secrets/authentik_postgress_passwd";
      };
      default = { };
      description = ''
        Attribute set containing paths to files to add to the environment of the authentik ${name}.${lib.optionalString global " These overwrite the global secret files."}
        The files are not added to the nix store, so they can be used to pass secrets.
        Refer to the [documentation](https://docs.goauthentik.io/install-config/configuration/) for options.
      '';
    };
  };

  mkOutpost =
    name:
    {
      enable = mkEnableOption "the authentik ${name} outpost";
      package = mkPackageOption pkgs "authentik.outposts.${name}" {
        default = [
          "authentik"
          "outposts"
          name
        ];
      };
      environmentFile = mkOption {
        type = secret;
        example = "/run/secrets/authentik_${name}";
        default = null;
        description = ''
          Path of a file with extra environment variables to be loaded from disk.
          This file is not added to the nix store, so it can be used to pass secrets to authentik ${name} outpost.
          Refer to the [documentation](https://docs.goauthentik.io/install-config/configuration/) for options.
        '';
      };
    }
    // mkEnvOptions "${name} outpost" false;

  mkOutpostConfig =
    name:
    mkIf cfg.outposts.${name}.enable {
      description = "authentik ${name} outpost";
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.outposts.${name}.environment // (credentialsEnv [ "outposts" name ] { });
      serviceConfig = commonServiceConfig // {
        ExecStart = lib.getExe cfg.outposts.${name}.package;
        EnvironmentFile = cfg.outposts.${name}.environmentFile;
        LoadCredential = credentials [ "outposts" name ] { };
        DynamicUser = true;
      };
    };
in
{
  options.services.authentik = {
    enable = mkEnableOption "authentik, the open-source Identity Provider that emphasizes flexibility and versatility";
    package = mkPackageOption pkgs "authentik" {
      default = [ "authentik" ];
    };

    user = mkOption {
      type = types.str;
      default = "authentik";
      description = "The user authentik should run as";
    };
    group = mkOption {
      type = types.str;
      default = "authentik";
      description = "The group authentik should run as.";
    };

    database = {
      createLocally = mkEnableOption "a local PostgreSQL instance for authentik." // {
        default = true;
      };
      host = mkOption {
        type = types.str;
        default = "/run/postgresql";
        example = "localhost";
        description = "Hostname or IP address of your PostgreSQL server";
      };
      port = mkOption {
        type = types.port;
        default = 5432;
        description = "Port on which PostgreSQL is listening";
      };
      user = mkOption {
        type = types.str;
        default = "authentik";
        description = "Username that authentik will use to authenticate with PostgreSQL";
      };
      name = mkOption {
        type = types.str;
        default = "authentik";
        description = "The name of the database for authentik to use";
      };
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        AUTHENTIK_LOG_LEVEL = "warning";
      };
      description = ''
        Extra configuration environment variables. Refer to the [documentation](https://docs.goauthentik.io/install-config/configuration) for options. These variables are shared between the authentik worker and server.
      '';
    };

    server = {
      host = mkOption {
        type = types.str;
        default = "127.0.0.1"; # Authentik errors on `localhost`
        description = "Host on which the authentik server will listen";
      };
      port = mkOption {
        type = types.port;
        default = 9000;
        description = "Port on which the authentik server will listen";
      };
      metricsPort = mkOption {
        type = types.port;
        default = 9300;
        description = "The port on which the authentik server exposes prometheus metrics";
      };
    }
    // mkEnvOptions "server" true;

    worker = {
      host = mkOption {
        type = types.str;
        default = "127.0.0.1"; # Authentik errors on `localhost`
        description = "Host on which the authentik worker will listen";
      };
      port = mkOption {
        type = types.port;
        default = 9001;
        description = "Port on which the authentik worker will listen";
      };
      metricsPort = mkOption {
        type = types.port;
        default = 9301;
        description = "The port on which the authentik worker exposes prometheus metrics";
      };
    }
    // mkEnvOptions "worker" true;

    environmentFile = mkOption {
      type = secret;
      example = "/run/secrets/authentik";
      default = null;
      description = ''
        Path of a file with extra environment variables to be loaded from disk. They are shared between the authentik server and worker.
        This file is not added to the nix store, so it can be used to pass secrets to authentik.
        Refer to the [documentation](https://docs.goauthentik.io/install-config/configuration/) for options.
        Authentik needs at least a secret key. To set a database password use AUTHENTIK_POSTGRESQL__PASSWORD:
        ```
        AUTHENTIK_SECRET_KEY=<secret>
        AUTHENTIK_POSTGRESQL__PASSWORD=<pass>
        ```
      '';
    };

    secretFiles = mkOption {
      type = types.attrsOf secret;
      example = {
        AUTHENTIK_SECRET_KEY = "/run/secrets/authentik_secret_key";
        AUTHENTIK_POSTGRESQL__PASSWORD = "/run/secrets/authentik_postgress_passwd";
      };
      default = { };
      description = ''
        Attribute set containing paths to files to add to the environment of authentik. They are shared between the authentik server and worker.
        The files are not added to the nix store, so they can be used to pass secrets to authentik.
        Refer to the [documentation](https://docs.goauthentik.io/install-config/configuration/) for options.
        Authentik needs at least a secret key. To set a database password use AUTHENTIK_POSTGRESQL__PASSWORD.
      '';
    };

    outposts = {
      ldap = mkOutpost "ldap";
      radius = mkOutpost "radius";
      proxy = mkOutpost "proxy";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {

        assertion = cfg.database.createLocally -> cfg.database.name == cfg.database.user;
        message = "The postgres module requires the database name and the database user name to be the same.";
      }
      {
        assertion = cfg.environmentFile == null -> cfg.secretFiles ? "AUTHENTIK_SECRET_KEY";
        message = ''
          Authentik needs at least a secret key to run.
          Use either the environmentFile or secretFiles.AUTHENTIK_SECRET_KEY to provide one.
        '';
      }
    ];

    services.authentik.environment = {
      AUTHENTIK_POSTGRESQL__HOST = cfg.database.host;
      AUTHENTIK_POSTGRESQL__PORT = toString cfg.database.port;
      AUTHENTIK_POSTGRESQL__USER = cfg.database.user;
      AUTHENTIK_POSTGRESQL__NAME = cfg.database.name;
      AUTHENTIK_OUTPOSTS__DISCOVER = "false";
    };

    services.authentik.server.environment = {
      AUTHENTIK_LISTEN__HTTP = "${cfg.server.host}:${toString cfg.server.port}";
      AUTHENTIK_LISTEN__METRICS = "${cfg.server.host}:${toString cfg.server.metricsPort}";
    };

    services.authentik.worker.environment = {
      AUTHENTIK_LISTEN__HTTP = "${cfg.worker.host}:${toString cfg.worker.port}";
      AUTHENTIK_LISTEN__METRICS = "${cfg.worker.host}:${toString cfg.worker.metricsPort}";
    };

    systemd.services.authentik-server = {
      description = "authentik server";
      requires = after;
      inherit after;
      wantedBy = [ "multi-user.target" ];
      environment =
        cfg.environment // cfg.server.environment // (credentialsEnv [ "server" ] cfg.secretFiles);
      serviceConfig = commonServiceConfig // {
        ExecStart = "${lib.getExe cfg.package} server";
        EnvironmentFile = cfg.environmentFile;
        LoadCredential = credentials [ "server" ] cfg.secretFiles;
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = "authentik";
      };
    };

    systemd.services.authentik-worker = {
      description = "authentik worker";
      requires = after;
      inherit after;
      wantedBy = [ "multi-user.target" ];
      environment =
        cfg.environment // cfg.worker.environment // (credentialsEnv [ "worker" ] cfg.secretFiles);
      serviceConfig = commonServiceConfig // {
        ExecStart = "${lib.getExe cfg.package} worker";
        EnvironmentFile = cfg.environmentFile;
        LoadCredential = credentials [ "server" ] cfg.secretFiles;
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = "authentik";
      };
    };

    systemd.services.authentik-ldap-outpost = mkOutpostConfig "ldap";
    systemd.services.authentik-proxy-outpost = mkOutpostConfig "proxy";
    systemd.services.authentik-radius-outpost = mkOutpostConfig "radius";

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
    };

    users.users = mkIf (cfg.user == "authentik") {
      authentik = {
        name = "authentik";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "authentik") { authentik = { }; };
  };

  meta.maintainers = with lib.maintainers; [
    jvanbruegge
  ];
}
