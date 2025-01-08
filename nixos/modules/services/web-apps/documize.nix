{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.services.documize;

  mkParams =
    optional:
    lib.concatMapStrings (
      name:
      let
        predicate = optional -> cfg.${name} != null;
        template = " -${name} '${toString cfg.${name}}'";
      in
      lib.optionalString predicate template
    );

in
{
  options.services.documize = {
    enable = lib.mkEnableOption "Documize Wiki";

    stateDirectoryName = lib.mkOption {
      type = lib.types.str;
      default = "documize";
      description = ''
        The name of the directory below {file}`/var/lib/private`
        where documize runs in and stores, for example, backups.
      '';
    };

    package = lib.mkPackageOption pkgs "documize-community" { };

    salt = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "3edIYV6c8B28b19fh";
      description = ''
        The salt string used to encode JWT tokens, if not set a random value will be generated.
      '';
    };

    cert = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The {file}`cert.pem` file used for https.
      '';
    };

    key = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The {file}`key.pem` file used for https.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5001;
      description = ''
        The http/https port number.
      '';
    };

    forcesslport = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = ''
        Redirect given http port number to TLS.
      '';
    };

    offline = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Set `true` for offline mode.
      '';
      apply = v: if true == v then 1 else 0;
    };

    dbtype = lib.mkOption {
      type = lib.types.enum [
        "mysql"
        "percona"
        "mariadb"
        "postgresql"
        "sqlserver"
      ];
      default = "postgresql";
      description = ''
        Specify the database provider: `mysql`, `percona`, `mariadb`, `postgresql`, `sqlserver`
      '';
    };

    db = lib.mkOption {
      type = lib.types.str;
      description = ''
        Database specific connection string for example:
        - MySQL/Percona/MariaDB:
          `user:password@tcp(host:3306)/documize`
        - MySQLv8+:
          `user:password@tcp(host:3306)/documize?allowNativePasswords=true`
        - PostgreSQL:
          `host=localhost port=5432 dbname=documize user=admin password=secret sslmode=disable`
        - MSSQL:
          `sqlserver://username:password@localhost:1433?database=Documize` or
          `sqlserver://sa@localhost/SQLExpress?database=Documize`
      '';
    };

    location = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        reserved
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.documize-server = {
      description = "Documize Wiki";
      documentation = [ "https://documize.com/" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.concatStringsSep " " [
          "${cfg.package}/bin/documize"
          (mkParams false [
            "db"
            "dbtype"
            "port"
          ])
          (mkParams true [
            "offline"
            "location"
            "forcesslport"
            "key"
            "cert"
            "salt"
          ])
        ];
        Restart = "always";
        DynamicUser = "yes";
        StateDirectory = cfg.stateDirectoryName;
        WorkingDirectory = "/var/lib/${cfg.stateDirectoryName}";
      };
    };
  };
}
