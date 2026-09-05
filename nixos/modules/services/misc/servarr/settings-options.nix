{ lib, pkgs }:
{
  mkServarrSettingsOptions =
    name: port:
    lib.mkOption {
      type = lib.types.submodule {
        freeformType = (pkgs.formats.ini { }).type;
        options = {
          update = {
            mechanism = lib.mkOption {
              type =
                with lib.types;
                nullOr (enum [
                  "external"
                  "builtIn"
                  "script"
                ]);
              description = "which update mechanism to use";
              default = "external";
            };
            automatically = lib.mkOption {
              type = lib.types.bool;
              description = "Automatically download and install updates.";
              default = false;
            };
          };
          server = {
            port = lib.mkOption {
              type = lib.types.port;
              description = "Port Number";
              default = port;
            };
          };
          log = {
            analyticsEnabled = lib.mkOption {
              type = lib.types.bool;
              description = "Send Anonymous Usage Data";
              default = false;
            };
          };
        };
      };
      example = lib.options.literalExpression ''
        {
          update.mechanism = "internal";
          server = {
            urlbase = "localhost";
            port = ${toString port};
            bindaddress = "*";
          };
        }
      '';
      default = { };
      description = ''
        Attribute set of arbitrary config options.
        Please consult the documentation at the [wiki](https://wiki.servarr.com/useful-tools#using-environment-variables-for-config).

        WARNING: this configuration is stored in the world-readable Nix store!
        For secrets use [](#opt-services.${name}.environmentFiles).
      '';
    };

  mkServarrEnvironmentFiles =
    name:
    lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Environment file to pass secret configuration values.
        Each line must follow the `${lib.toUpper name}__SECTION__KEY=value` pattern.
        Please consult the documentation at the [wiki](https://wiki.servarr.com/useful-tools#using-environment-variables-for-config).
      '';
    };

  mkServarrPostgresqlOption =
    name:
    lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to automatically create local PostgreSQL databases for ${name}.
        The service connects through the local Unix socket using peer
        authentication.
      '';
    };

  mkServarrPostgresqlConfig =
    {
      cfg,
      name,
      postgresqlPort,
      user,
    }:
    let
      mainDb = "${name}-main";
      logDb = "${name}-log";
      localPostgresql = cfg.enable && cfg.database.createLocally;
    in
    lib.mkIf localPostgresql {
      assertions = [
        {
          assertion = builtins.match "[a-zA-Z_][a-zA-Z0-9_-]*" user != null;
          message = "services.${name}.user must be a valid PostgreSQL role name when database.createLocally is true.";
        }
      ];

      services.postgresql = {
        enable = true;
        ensureDatabases = [
          mainDb
          logDb
        ];
        ensureUsers = [ { name = user; } ];
      };

      services.${name}.settings.postgres = {
        host = "/run/postgresql";
        port = postgresqlPort;
        inherit user mainDb logDb;
      };

      systemd.services = {
        postgresql-setup.postStart = lib.mkAfter ''
          psql -tAc 'ALTER DATABASE "${mainDb}" OWNER TO "${user}";'
          psql -tAc 'ALTER DATABASE "${logDb}" OWNER TO "${user}";'
        '';

        ${name} = {
          after = [ "postgresql.target" ];
          requires = [ "postgresql.target" ];
        };
      };
    };

  mkServarrSettingsEnvVars =
    name: settings:
    lib.pipe settings [
      (lib.mapAttrsRecursive (
        path: value:
        lib.optionalAttrs (value != null) {
          name = lib.toUpper "${name}__${lib.concatStringsSep "__" path}";
          value = toString (if lib.isBool value then lib.boolToString value else value);
        }
      ))
      (lib.collect (x: lib.isString x.name or false && lib.isString x.value or false))
      lib.listToAttrs
    ];
}
