{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.documize;

  mkParams = optional: concatMapStrings (name: let
    predicate = optional -> cfg.${name} != null;
    template = " -${name} '${toString cfg.${name}}'";
  in optionalString predicate template);

in {
  options.services.documize = {
    enable = mkEnableOption "Documize Wiki";

    package = mkOption {
      type = types.package;
      default = pkgs.documize-community;
      description = ''
        Which package to use for documize.
      '';
    };

    salt = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "3edIYV6c8B28b19fh";
      description = ''
        The salt string used to encode JWT tokens, if not set a random value will be generated.
      '';
    };

    cert = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The <filename>cert.pem</filename> file used for https.
      '';
    };

    key = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The <filename>key.pem</filename> file used for https.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 5001;
      description = ''
        The http/https port number.
      '';
    };

    forcesslport = mkOption {
      type = types.nullOr types.port;
      default = null;
      description = ''
        Redirect given http port number to TLS.
      '';
    };

    offline = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Set <literal>true</literal> for offline mode.
      '';
      apply = v: if true == v then 1 else 0;
    };

    dbtype = mkOption {
      type = types.enum [ "mysql" "percona" "mariadb" "postgresql" "sqlserver" ];
      default = "postgresql";
      description = ''
        Specify the database provider:
        <simplelist type='inline'>
          <member><literal>mysql</literal></member>
          <member><literal>percona</literal></member>
          <member><literal>mariadb</literal></member>
          <member><literal>postgresql</literal></member>
          <member><literal>sqlserver</literal></member>
        </simplelist>
      '';
    };

    db = mkOption {
      type = types.str;
      description = ''
        Database specific connection string for example:
        <itemizedlist>
        <listitem><para>MySQL/Percona/MariaDB:
          <literal>user:password@tcp(host:3306)/documize</literal>
        </para></listitem>
        <listitem><para>MySQLv8+:
          <literal>user:password@tcp(host:3306)/documize?allowNativePasswords=true</literal>
        </para></listitem>
        <listitem><para>PostgreSQL:
          <literal>host=localhost port=5432 dbname=documize user=admin password=secret sslmode=disable</literal>
        </para></listitem>
        <listitem><para>MSSQL:
          <literal>sqlserver://username:password@localhost:1433?database=Documize</literal> or
          <literal>sqlserver://sa@localhost/SQLExpress?database=Documize</literal>
        </para></listitem>
        </itemizedlist>
      '';
    };

    location = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        reserved
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.documize-server = {
      description = "Documize Wiki";
      documentation = [ https://documize.com/ ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = concatStringsSep " " [
          "${cfg.package}/bin/documize"
          (mkParams false [ "db" "dbtype" "port" ])
          (mkParams true [ "offline" "location" "forcesslport" "key" "cert" "salt" ])
        ];
        Restart = "always";
        DynamicUser = "yes";
      };
    };
  };
}
