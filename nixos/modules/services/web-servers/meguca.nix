{ config, lib, pkgs, ... }:

let
  inherit (lib) generators literalExample mkEnableOption mkIf mkOption recursiveUpdate types;
  cfg = config.services.meguca;
  dataDir = "/var/lib/meguca";
  configFile = pkgs.writeText "config.json" (generators.toJSON {} (recursiveUpdate defaultSettings cfg.settings));

  defaultSettings = {
    debug = cfg.debug;
    imager_mode = cfg.imagerMode;
    database = cfg.databaseURL;
    cache_size = cfg.cacheSize;

    server = {
      address = cfg.listenAddress;
      reverse_proxied = cfg.reverseProxy;
    };

    test = {
      database = cfg.testDatabaseURL;
    };
  };
in with lib; {
  options.services.meguca = {
    enable = mkEnableOption "meguca";

    settings = mkOption {
      type = with types; attrsOf (oneOf [ str int float bool ]);
      default = {};
      example = literalExample "debug = true;";

      description = ''
        <filename>db_conf.json</filename> configuration. Refer to
        <link xlink:href="https://github.com/bakape/meguca"/>
        for details on supported values;
      '';
    };

    debug = mkOption {
      type = types.bool;
      default = false;

      description = ''
        Should the server be running in debug mode. Debug mode has more verbose
        logging and prints all logs to stdout. If disabled, error logs will be
        printed to the `errors.log` file.
      '';
    };

    imagerMode = mkOption {
      type = types.int;
      default = 0;

      description = ''
        Sets what functionality this instance of the application server will
		    handle. The functionality is divided around handling image-related
		    processing.

		    0: handle image processing and serving and all other functionality
		    1: handle all functionality except for image processing and serving
		    2: only handle image processing and serving
      '';
    };

    databaseURL = mkOption {
      type = types.str;
      default = "postgres:///meguca?user=meguca&password=meguca&host=/run/postgresql&sslmode=disable";
      example = "postgres://meguca:meguca@localhost:5432/meguca?sslmode=disable";
      description = "Database URL to connect to on server start.";
    };

    testDatabaseURL = mkOption {
      type = types.str;
      default = "postgres:///meguca_test?user=meguca&password=meguca&host=/run/postgresql&sslmode=disable";
      example = "postgres://meguca:meguca@localhost:5432/meguca_test?sslmode=disable";

      description = ''
        Database URL to use during tests.

        This URL only serves as the base. The actual databases are created
        and dropped during testing automatically with prefixes for each
        database according to the submodule using this test database for
        running unit tests. This division allows database-related for each
        submodule to be run concurrently, overall reducing the runtime of
        unit tests.

        To allow database creation during tests the role used must have the
        necessary PostgreSQL permissions. These can be granted by running

          ALTER USER $user_name WITH CREATEDB;

        as the administrator postgres user in the psql shell.
      '';
    };

    cacheSize = mkOption {
      type = types.float;
      default = 128.0;
      example = 256.0;

      description = ''
        Size limit of internal cache in MB. Once limit is exceeded, the least
		    recently used records from the cache will be evicted.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = ":8000";
      example = ":9001";
      description = "Address to listen on for incoming connections.";
    };

    reverseProxy = mkOption {
      type = types.bool;
      default = false;

      description = ''
        The server can only be accessed by clients through a reverse proxy
        like NGINX and thus can safely honour "X-Forwarded-For" headers
        for client IP resolution.
      '';
    };

    videoPaths = mkOption {
      type = with types; listOf path;
      default = [ ];
      example = [ "/home/okina/Videos/tehe_pero.webm" ];
      description = "Videos that will be symlinked into www/videos.";
    };
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      extraConfig = "max_connections = 1024";
      ensureDatabases = [ "meguca" "meguca_test" ];

      ensureUsers = [{
        name = "meguca";

        ensurePermissions = {
          "DATABASE meguca" = "ALL PRIVILEGES";
          "DATABASE meguca_test" = "ALL PRIVILEGES";
        };
      }];
    };

    systemd.services.meguca = {
      description = "meguca imageboard server";
      after = [ "network-online.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      environment.HOME = dataDir;

      preStart = ''
        mkdir -p $STATE_DIRECTORY/www/videos
        ln -sf ${configFile} $STATE_DIRECTORY/config.json
        ln -sf ${pkgs.meguca}/share/www/* $STATE_DIRECTORY/www

        for vid in ${escapeShellArg cfg.videoPaths}; do
          ln -sf $vid $STATE_DIRECTORY/www/videos
        done

        find $STATE_DIRECTORY/www/videos -xtype l -delete
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        StartLimitInterval = "6s";
        StartLimitBurst = 1;
        User = "meguca";
        DynamicUser = true;
        StateDirectory = "meguca";
        WorkingDirectory = dataDir;
        PIDFile = "${dataDir}/.pid";
        ExecStart = "${pkgs.meguca}/bin/meguca";
        ExecReload = "${pkgs.coreutils}/bin/kill -USR2 $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -s TERM $MAINPID";
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "meguca" "baseDir" ] [ "services" "meguca" "dataDir" ])
    (mkRenamedOptionModule [ "services" "meguca" "assumeReverseProxy" ] [ "services" "meguca" "reverseProxy" ])
    (mkRemovedOptionModule [ "services" "meguca" "dataDir" ] "Meguca will store data by default in /var/lib/meguca")
    (mkRemovedOptionModule [ "services" "meguca" "password" ] "Use databaseURL")
    (mkRemovedOptionModule [ "services" "meguca" "passwordFile" ] "Use databaseURL")
    (mkRemovedOptionModule [ "services" "meguca" "postgresArgs" ] "Use databaseURL")
    (mkRemovedOptionModule [ "services" "meguca" "postgresArgsFile" ] "Use databaseURL")
  ];

  meta.maintainers = with maintainers; [ chiiruno ];
}
