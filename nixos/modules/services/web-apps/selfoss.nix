{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.selfoss;

  poolName = "selfoss_pool";

  dataDir = "/var/lib/selfoss";

  selfoss-config =
  let
    db_type = cfg.database.type;
    default_port = if (db_type == "mysql") then 3306 else 5342;
  in
  pkgs.writeText "selfoss-config.ini" ''
    [globals]
    ${lib.optionalString (db_type != "sqlite") ''
      db_type=${db_type}
      db_host=${cfg.database.host}
      db_database=${cfg.database.name}
      db_username=${cfg.database.user}
      db_password=${cfg.database.password}
      db_port=${toString (if (cfg.database.port != null) then cfg.database.port
                    else default_port)}
    ''
    }
    ${cfg.extraConfig}
  '';
in
  {
    options = {
      services.selfoss = {
        enable = mkEnableOption (lib.mdDoc "selfoss");

        user = mkOption {
          type = types.str;
          default = "nginx";
          description = lib.mdDoc ''
            User account under which both the service and the web-application run.
          '';
        };

        pool = mkOption {
          type = types.str;
          default = "${poolName}";
          description = lib.mdDoc ''
            Name of existing phpfpm pool that is used to run web-application.
            If not specified a pool will be created automatically with
            default values.
          '';
        };

      database = {
        type = mkOption {
          type = types.enum ["pgsql" "mysql" "sqlite"];
          default = "sqlite";
          description = lib.mdDoc ''
            Database to store feeds. Supported are sqlite, pgsql and mysql.
          '';
        };

        host = mkOption {
          type = types.str;
          default = "localhost";
          description = lib.mdDoc ''
            Host of the database (has no effect if type is "sqlite").
          '';
        };

        name = mkOption {
          type = types.str;
          default = "tt_rss";
          description = lib.mdDoc ''
            Name of the existing database (has no effect if type is "sqlite").
          '';
        };

        user = mkOption {
          type = types.str;
          default = "tt_rss";
          description = lib.mdDoc ''
            The database user. The user must exist and has access to
            the specified database (has no effect if type is "sqlite").
          '';
        };

        password = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The database user's password (has no effect if type is "sqlite").
          '';
        };

        port = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            The database's port. If not set, the default ports will be
            provided (5432 and 3306 for pgsql and mysql respectively)
            (has no effect if type is "sqlite").
          '';
        };
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra configuration added to config.ini
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.pools = mkIf (cfg.pool == "${poolName}") {
      ${poolName} = {
        user = "nginx";
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = "nginx";
          "listen.group" = "nginx";
          "listen.mode" = "0600";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
          "catch_workers_output" = 1;
        };
      };
    };

    systemd.services.selfoss-config = {
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -m 755 -p ${dataDir}
        cd ${dataDir}

        # Delete all but the "data" folder
        ls | grep -v data | while read line; do rm -rf $line; done || true

        # Create the files
        cp -r "${pkgs.selfoss}/"* "${dataDir}"
        ln -sf "${selfoss-config}" "${dataDir}/config.ini"
        chown -R "${cfg.user}" "${dataDir}"
        chmod -R 755 "${dataDir}"
      '';
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.selfoss-update = {
      serviceConfig = {
        ExecStart = "${pkgs.php}/bin/php ${dataDir}/cliupdate.php";
        User = "${cfg.user}";
      };
      startAt = "hourly";
      after = [ "selfoss-config.service" ];
      wantedBy = [ "multi-user.target" ];

    };

  };
}
