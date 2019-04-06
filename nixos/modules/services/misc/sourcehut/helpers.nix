{ lib }:

with lib;

{
  ### OAuth
  oauthOpts = { ... }: {
    options = {
      clientId = mkOption {
        type = types.either types.int types.str;
        default = "";
        description = ''
          OAuth client ID.
        '';
      };

      clientSecret = mkOption {
        type = types.str;
        default = "";
        description = ''
          OAuth client secret.
        '';
      };
    };
  };

  ### Repository
  repoOpts = { ... }: {
    options = {
      path = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to the repositories on disk.
        '';
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Owner of the root folder containing the repositories on disk.
        '';
      };
    };
  };

  ### PostgreSQL
  # dialect+driver://username:password@host:port/database
  # postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]
  generateConnectionString = cfg: let
    driver = optionalString (cfg.driver != null) "+${cfg.driver}";
    password = optionalString (cfg.password != null) ":${cfg.password}";
    credentials = optionalString (cfg.user != null) "${cfg.user}${password}@";
    host = optionalString (cfg.host != null) cfg.host;
    port = optionalString (cfg.port != null) ":${toString cfg.port}";
    database = optionalString (cfg.dbname != null) "/${cfg.dbname}";

    params = optionalString (cfg.params != null) "?${concatMapStringsSep "&"
      (attr: "${attr}=${toString cfg.params."${attr}"}")
      cfg.params}";
  in "postgresql${driver}://${credentials}${host}${port}${database}${params}";

  databaseOpts = { ... }: {
    options = {
      driver = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "psycopg2";
        description = ''
          The name of the DBAPI to be used to connect to the database using all lowercase letters.
        '';
      };

      # Self explanatory?
      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "";
      };

      # Self explanatory?
      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "";
      };

      host = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The fully qualified domain name of a network host, or its IP address
          as a set of four decimal digit groups separated by ".".
        '';
      };

      port = mkOption {
        type = types.nullOr types.port;
        default = null;
        description = ''
          The port number to connect to.
        '';
      };

      dbname = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The name of the database to connect to.
        '';
      };

      params = mkOption {
        type = types.nullOr (types.attrsOf (types.either types.int types.str));
        default = null;
        description = ''
          Extra parameters to pass to the connection string.
        '';
      };
    };
  };

  ### Redis
  # redis://:password@hostname:port/db_number
  generateRedisURL = cfg: let
    password = optionalString (cfg.password != null) ":${cfg.password}@";
    hostname = optionalString (cfg.hostname != null) cfg.hostname;
    port = optionalString (cfg.port != null) ":${toString cfg.port}";
    dbnumber = optionalString (cfg.dbnumber != null) (toString cfg.dbnumber);
  in "redis://${password}${hostname}${port}/${dbnumber}";

  redisOpts = { ... }: {
    options = {
      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
        '';
      };

      hostname = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
        '';
      };

      port = mkOption {
        type = types.nullOr types.port;
        default = null;
        description = ''
        '';
      };

      dbnumber = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
        '';
      };
    };
  };
}
