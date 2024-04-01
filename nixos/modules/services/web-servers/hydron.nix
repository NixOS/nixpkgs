{ config, lib, pkgs, ... }:

let
  cfg = config.services.hydron;
in with lib; {
  options.services.hydron = {
    enable = mkEnableOption "hydron";

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/hydron";
      example = "/home/okina/hydron";
      description = "Location where hydron runs and stores data.";
    };

    interval = mkOption {
      type = types.str;
      default = "weekly";
      example = "06:00";
      description = ''
        How often we run hydron import and possibly fetch tags. Runs by default every week.

        The format is described in
        {manpage}`systemd.time(7)`.
      '';
    };

    password = mkOption {
      type = types.str;
      default = "hydron";
      example = "dumbpass";
      description = "Password for the hydron database.";
    };

    passwordFile = mkOption {
      type = types.path;
      default = "/run/keys/hydron-password-file";
      example = "/home/okina/hydron/keys/pass";
      description = "Password file for the hydron database.";
    };

    postgresArgs = mkOption {
      type = types.str;
      description = "Postgresql connection arguments.";
      example = ''
        {
          "driver": "postgres",
          "connection": "user=hydron password=dumbpass dbname=hydron sslmode=disable"
        }
      '';
    };

    postgresArgsFile = mkOption {
      type = types.path;
      default = "/run/keys/hydron-postgres-args";
      example = "/home/okina/hydron/keys/postgres";
      description = "Postgresql connection arguments file.";
    };

    listenAddress = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "127.0.0.1:8010";
      description = "Listen on a specific IP address and port.";
    };

    importPaths = mkOption {
      type = types.listOf types.path;
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
    services.hydron.passwordFile = mkDefault (pkgs.writeText "hydron-password-file" cfg.password);
    services.hydron.postgresArgsFile = mkDefault (pkgs.writeText "hydron-postgres-args" cfg.postgresArgs);
    services.hydron.postgresArgs = mkDefault ''
      {
        "driver": "postgres",
        "connection": "user=hydron password=${cfg.password} host=/run/postgresql dbname=hydron sslmode=disable"
      }
    '';

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "hydron" ];
      ensureUsers = [
        { name = "hydron";
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0750 hydron hydron - -"
      "d '${cfg.dataDir}/.hydron' - hydron hydron - -"
      "d '${cfg.dataDir}/images' - hydron hydron - -"
      "Z '${cfg.dataDir}' - hydron hydron - -"

      "L+ '${cfg.dataDir}/.hydron/db_conf.json' - - - - ${cfg.postgresArgsFile}"
    ];

    systemd.services.hydron = {
      description = "hydron";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "hydron";
        Group = "hydron";
        ExecStart = "${pkgs.hydron}/bin/hydron serve"
        + optionalString (cfg.listenAddress != null) " -a ${cfg.listenAddress}";
      };
    };

    systemd.services.hydron-fetch = {
      description = "Import paths into hydron and possibly fetch tags";

      serviceConfig = {
        Type = "oneshot";
        User = "hydron";
        Group = "hydron";
        ExecStart = "${pkgs.hydron}/bin/hydron import "
        + optionalString cfg.fetchTags "-f "
        + (escapeShellArg cfg.dataDir) + "/images " + (escapeShellArgs cfg.importPaths);
      };
    };

    systemd.timers.hydron-fetch = {
      description = "Automatically import paths into hydron and possibly fetch tags";
      after = [ "network.target" "hydron.service" ];
      wantedBy = [ "timers.target" ];

      timerConfig = {
        Persistent = true;
        OnCalendar = cfg.interval;
      };
    };

    users = {
      groups.hydron.gid = config.ids.gids.hydron;

      users.hydron = {
        description = "hydron server service user";
        home = cfg.dataDir;
        group = "hydron";
        uid = config.ids.uids.hydron;
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "hydron" "baseDir" ] [ "services" "hydron" "dataDir" ])
  ];

  meta.maintainers = with maintainers; [ Madouura ];
}
