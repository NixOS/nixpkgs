{ config, lib, pkgs, ... }:

let
  inherit (lib) generators literalExample mkEnableOption mkIf mkOption recursiveUpdate types;
  cfg = config.services.hydron;
  dataDir = "/var/lib/hydron";
  configFile = pkgs.writeText "db_conf.json" (generators.toJSON {} (recursiveUpdate defaultSettings cfg.settings));

  defaultSettings = {
    driver = cfg.sqlDriver;
    connection = cfg.sqlConnection;
  };
in with lib; {
  options.services.hydron = {
    enable = mkEnableOption "hydron";

    settings = mkOption {
      type = with types; attrsOf (oneOf [ str ]);
      default = {};
      example = literalExample "driver = \"sqlite3\";";

      description = ''
        <filename>db_conf.json</filename> configuration. Refer to
        <link xlink:href="https://github.com/bakape/hydron"/>
        for details on supported values;
      '';
    };

    interval = mkOption {
      type = types.str;
      default = "weekly";
      example = "06:00";

      description = ''
        How often we run hydron import and possibly fetch tags. Runs by default every week.

        The format is described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>.
      '';
    };

    sqlDriver = mkOption {
      type = types.str;
      default = "postgres";
      example = "sqlite3";
      description = "SQL program to connect to.";
    };

    sqlConnection = mkOption {
      type = types.str;
      default = "user=hydron password=hydron host=/run/postgresql dbname=hydron sslmode=disable";
      example = "user=hydron password=dumbpass host=/run/postgresql dbname=hydron sslmode=disable";
      description = "SQL connection line.";
    };

    listenAddress = mkOption {
      type = types.str;
      default = ":8010";
      example = ":8020";
      description = "Listen on a specific IP address and port.";
    };

    importPaths = mkOption {
      type = with types; listOf path;
      default = [];
      example = [ "/home/okina/Pictures" ];
      description = "Paths that hydron will recursively import.";
    };

    fetchTags = mkOption {
      type = types.bool;
      default = true;
      description = "Fetch tags for imported images and webm from gelbooru.";
    };
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "hydron" ];

      ensureUsers = [{
        name = "hydron";
        ensurePermissions = { "DATABASE hydron" = "ALL PRIVILEGES"; };
      }];
    };

    systemd = {
      services = {
        hydron = {
          description = "hydron media tagger and organizer";
          after = [ "network.target" "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];
          environment.HOME = dataDir;

          preStart = ''
            mkdir -p $STATE_DIRECTORY/.hydron
            mkdir -p $STATE_DIRECTORY/images
            ln -sf ${configFile} $STATE_DIRECTORY/.hydron/db_conf.json
          '';

          serviceConfig = {
            User = "hydron";
            DynamicUser = true;
            StateDirectory = "hydron";
            WorkingDirectory = dataDir;
            ExecStart = "${pkgs.hydron}/bin/hydron serve -a ${cfg.listenAddress}";
          };
        };

        hydron-fetch = {
          description = "Import paths into hydron and possibly fetch tags";
          environment.HOME = dataDir;

          serviceConfig = {
            Type = "oneshot";
            User = "hydron";
            DynamicUser = true;
            StateDirectory = "hydron";
            WorkingDirectory = dataDir;
            ExecStart = "${pkgs.hydron}/bin/hydron import "
            + optionalString cfg.fetchTags "-f "
            + "$STATE_DIRECTORY/images ${escapeShellArgs cfg.importPaths}";
          };
        };
      };

      timers.hydron-fetch = {
        description = "Automatically import paths into hydron and possibly fetch tags";
        after = [ "network.target" "hydron.service" ];
        wantedBy = [ "timers.target" ];

        timerConfig = {
          Persistent = true;
          OnCalendar = cfg.interval;
        };
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "hydron" "baseDir" ] [ "services" "hydron" "dataDir" ])
    (mkRemovedOptionModule [ "services" "hydron" "dataDir" ] "Hydron will store data by default in /var/lib/hydron")
    (mkRemovedOptionModule [ "services" "hydron" "password" ] "Use sqlConnection")
    (mkRemovedOptionModule [ "services" "hydron" "passwordFile" ] "Use sqlConnection")
    (mkRemovedOptionModule [ "services" "hydron" "postgresArgs" ] "Use sqlDrive and sqlConnection")
    (mkRemovedOptionModule [ "services" "hydron" "postgresArgsFile" ] "Use sqlDrive and sqlConnection")
  ];

  meta.maintainers = with maintainers; [ chiiruno ];
}
