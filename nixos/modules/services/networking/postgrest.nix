{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.services.postgrest;
  inherit (lib) mkOption types literalExample mdDoc;
in {
  options.services.postgrest = {
    enable = lib.mkEnableOption (mdDoc "postgrest");

    dbURI = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "postgres://username:password@localhost:5432/books";
      description = mdDoc ''
        Full Database URI containing username, password, host, port, and database name.
      '';
    };

    postgresUser = mkOption {
      type = types.str;
      example = "root";
      description = mdDoc ''
        Username for postgres admin.
      '';
    };
    postgresPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = mdDoc ''
        Password for postgres admin.
      '';
    };
    postgresHost = mkOption {
      type = types.str;
      default = "localhost";
      example = "localhost";
      description = mdDoc ''
        Host for the database.
      '';
    };
    postgresDatabase = mkOption {
      type = types.str;
      default = "postgres";
      example = "books";
      description = mdDoc ''
        Name of the database to connect postgrest.
      '';
    };
    postgresSchema = mkOption {
      type = types.str;
      default = "public";
      example = "api";
      description = mdDoc ''
        Schema of the database.
      '';
    };
    postgresPort = mkOption {
      type = types.port;
      default = 5432;
      description = mdDoc ''
        Port for the database.
      '';
    };
    port = mkOption {
      type = types.port;
      default = 3000;
      description = mdDoc ''
        Port for the database.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.haskellPackages.postgrest;
      description = mdDoc ''
        postgrest package override.
      '';
    };
    anonRole = mkOption {
      type = types.str;
      example = "anon";
      description = mdDoc ''
        Role that will access the postgrest API anonymously.
      '';
    };
    extraConf = mkOption {
      type = types.str;
      default = "";
      description = mdDoc ''
        Any extra config.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.postgrest = {
      wantedBy = ["multi-user.target"];
      after = ["postgresql.service"];
      script = let
        credentials =
          if cfg.postgresPassword == null
          then cfg.postgresUser
          else "${cfg.postgresUser}:${cfg.postgresPassword}";
        dbURI =
          if cfg.dbURI != null
          then cfg.dbURI
          else "postgres://${credentials}@${cfg.postgresHost}:${toString cfg.postgresPort}/${cfg.postgresDatabase}";
        postgrestConfig = pkgs.writeText "postgrest.conf" ''
          db-uri = "${dbURI}"
          server-port = ${toString cfg.port}
          db-anon-role = "${cfg.anonRole}"
          db-schema = "${cfg.postgresSchema}"
          ${cfg.extraConf}
        '';
      in "${cfg.package}/bin/postgrest ${postgrestConfig}";
    };
  };
}
