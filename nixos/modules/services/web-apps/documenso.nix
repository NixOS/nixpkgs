{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.documenso;
in
{
  options.services.documenso = {

    enable = lib.mkEnableOption "Documenso service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.documenso;
      defaultText = lib.literalExpression "pkgs.documenso";
      description = ''
        The documenso package to use.
      '';
    };

    serverPort = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port the documenso server listens on.";
    };

    database = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "documenso";
        description = "Database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "documenso";
        description = "Database user.";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "postgres://${config.services.documenso.database.user}@localhost/${config.services.documenso.database.name}?host=/run/postgresql";
        defaultText = lib.literalExpression ''
          "postgres://documenso@localhost/documenso?host=/run/postgresql";
        '';
        description = ''
          Database url. Note that any secret here would be world-readable. Use
          `services.documenso.environmentFile` instead to include database
          secrets.
        '';
      };

      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to create a local database automatically.";
      };

      seedDatabase = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to seed the database with initial users and teams and
          templates. If you set this to 'true' you can login after first
          install with `admin@documenso.com` and `password` as password.
        '';
      };

    };

    authSecret = lib.mkOption {
      type = lib.types.str;
      default = "secret";
      description = ''
        NextAuth Secret. Used to encrypt the NextAuth.js JWT, and to hash
        email verification tokens.
        Change this value for production environments.
      '';
    };

    privateEncryptionKey = lib.mkOption {
      type = lib.types.str;
      default = "secretsecret";
      description = ''
        Application Key for symmetric encryption and decryption
        This should be a random string of at least 32 characters.
        Change this value for production environments.
      '';
    };

    privateEncryptionSecondairyKey = lib.mkOption {
      type = lib.types.str;
      default = "secretsecretsecret";
      description = ''
        Application Key for symmetric encryption and decryption
        This should be a random string of at least 32 characters.
        Change this value for production environments.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Environment file to load extra environment variables from.
        See https://github.com/documenso/documenso/blob/main/.env.example for
        common options.
      '';
    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.database.name == cfg.database.user;
        message = ''
          Automatically provisioning the documenso database requires both database name and database user to be equal. '${cfg.database.name}' != '${cfg.database.user}'
          To fix this problem, assign the same value to both options services.documenso.database.{name,user}.
        '';
      }
    ];

    services.postgresql = lib.optionalAttrs (cfg.database.createLocally) {
      enable = lib.mkDefault true;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
    };

    systemd.services =
      let

        environment = {
          NEXTAUTH_SECRET = cfg.authSecret;
          NEXT_PRIVATE_DATABASE_URL = cfg.database.url;
          NEXT_PRIVATE_DIRECT_DATABASE_URL = cfg.database.url;
          NEXT_PRIVATE_ENCRYPTION_KEY = cfg.privateEncryptionKey;
          NEXT_PRIVATE_ENCRYPTION_SECONDARY_KEY = cfg.privateEncryptionSecondairyKey;
          NEXT_PUBLIC_WEBAPP_URL = "http://localhost:${builtins.toString cfg.serverPort}";
          NEXT_PRIVATE_INTERNAL_WEBAPP_URL = "http://localhost:${builtins.toString cfg.serverPort}";
          PORT = builtins.toString cfg.serverPort;
          #NEXT_PRIVATE_JOBS_PROVIDER="local";
        };

      in
      {
        documenso-server = {
          inherit environment;
          description = "documenso server";
          wantedBy = [ "multi-user.target" ];
          requires = [ "postgresql.target" ];
          after = [ "postgresql.target" ];
          serviceConfig = {
            DynamicUser = true;
            User = cfg.database.user;
            ExecStart = "${cfg.package}/bin/documenso";
            Restart = "always";
          }
          // lib.optionalAttrs (cfg.environmentFile != null) { EnvironmentFile = cfg.environmentFile; };
        };
      }
      // lib.optionalAttrs (cfg.database.seedDatabase == true) {
        documenso-seed-database = {

          inherit environment;

          description = "documenso database setup";
          requires = [ "documenso-server.service" ];
          after = [ "documenso-server.service" ];

          script = ''
            #!${pkgs.bash}/bin/bash
            export PKG_CONFIG_PATH=${pkgs.openssl.dev}/lib/pkgconfig;
            export PRISMA_QUERY_ENGINE_LIBRARY=${pkgs.prisma-engines}/lib/libquery_engine.node
            export PRISMA_QUERY_ENGINE_BINARY=${pkgs.prisma-engines}/bin/query-engine
            export PRISMA_SCHEMA_ENGINE_BINARY=${pkgs.prisma-engines}
            export PATH=$PATH:${cfg.package}/node_modules/.bin
            cd ${cfg.package}/packages/prisma
            ${pkgs.prisma}/bin/prisma db seed
          '';

          serviceConfig = {
            DynamicUser = true;
            User = cfg.database.user;
            Type = "oneshot";
            RemainAfterExit = true;
          }
          // lib.optionalAttrs (cfg.environmentFile != null) { EnvironmentFile = cfg.environmentFile; };
        };
      };
  };
}
