{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mapAttrs
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.selfoss;

  poolName = "selfoss_pool";

  dataDir = "/var/lib/selfoss";

  settingsFormat = pkgs.formats.iniWithGlobalSection {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString =
        v:
        if v == null then
          ""
        else if v == true then
          "1"
        else if v == false then
          "0"
        else
          lib.generators.mkValueStringDefault { } v;
    } "=";
  };

  selfoss-config = settingsFormat.generate "config.ini" { globalSection = cfg.settings; };
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "selfoss" "database" "type" ]
      [ "services" "selfoss" "settings" "db_type" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "selfoss" "database" "host" ]
      [ "services" "selfoss" "settings" "db_host" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "selfoss" "database" "name" ]
      [ "services" "selfoss" "settings" "db_database" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "selfoss" "database" "username" ]
      [ "services" "selfoss" "settings" "db_user" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "selfoss" "database" "password" ]
      [ "services" "selfoss" "settings" "db_password" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "selfoss" "database" "port" ]
      [ "services" "selfoss" "settings" "db_port" ]
    )
    (lib.mkRemovedOptionModule [ "services" "selfoss" "extraConfig" ] ''
      Use services.selfoss.settings instead.

      This is part of the general move to use structured settings instead of raw
      text for config as introduced by RFC0042:
      https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md
    '')
  ];

  options = {
    services.selfoss = {
      enable = mkEnableOption "selfoss";

      user = mkOption {
        type = types.str;
        default = config.services.nginx.user;
        defaultText = lib.literalExpression "config.services.nginx.user";
        description = ''
          User account under which both the service and the web-application run.
        '';
      };

      pool = mkOption {
        type = types.str;
        default = "${poolName}";
        description = ''
          Name of existing phpfpm pool that is used to run web-application.
          If not specified a pool will be created automatically with
          default values.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          # Only single level of config supported
          freeformType = types.attrsOf settingsFormat.lib.types.atom;

          options = {
            db_type = mkOption {
              type = types.enum [
                "pgsql"
                "mysql"
                "sqlite"
              ];
              default = "sqlite";
              description = ''
                Database to store feeds. Supported are sqlite, pgsql and mysql.
              '';
            };

            db_host = mkOption {
              type = types.str;
              default = "localhost";
              description = ''
                Host of the database (has no effect if type is "sqlite").
              '';
            };

            db_database = mkOption {
              type = types.str;
              default = "tt_rss";
              description = ''
                Name of the existing database (has no effect if type is "sqlite").
              '';
            };

            db_user = mkOption {
              type = types.str;
              default = "tt_rss";
              description = ''
                The database user. The user must exist and has access to
                the specified database (has no effect if type is "sqlite").
              '';
            };

            db_password = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                The database user's password (has no effect if type is "sqlite").
              '';
            };

            db_port = mkOption {
              type = types.nullOr types.port;
              default = null;
              description = ''
                The database's port. If not set, the default ports will be
                provided (5432 and 3306 for pgsql and mysql respectively)
                (has no effect if type is "sqlite").
              '';
            };
          };
        };

        default = { };

        description = ''
          Configuration for selfoss, see
          <https://selfoss.aditu.de/docs/administration/options/>
          for supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.pools = mkIf (cfg.pool == "${poolName}") {
      ${poolName} = {
        user = mkDefault config.services.nginx.user;
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
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
      serviceConfig = {
        Type = "oneshot";
        StateDirectory = [ (baseNameOf dataDir) ];
        StateDirectoryMode = "0755";
        WorkingDirectory = dataDir;
      };
      script = ''
        # Delete all but the "data" folder
        ls | grep -v data | while read line; do rm -rf $line; done || true

        # Create the files
        cp -r \
          "${pkgs.selfoss}/.htaccess" \
          "${pkgs.selfoss}/.nginx.conf" \
          "${pkgs.selfoss}/"* \
          "${dataDir}"
        ln -sf "${selfoss-config}" "${dataDir}/config.ini"
        chown -R "${cfg.user}" "${dataDir}"
        chmod -R 755 "${dataDir}"
      '';
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.selfoss-update = {
      serviceConfig = {
        ExecStart = "${pkgs.php83}/bin/php ${dataDir}/cliupdate.php";
        StateDirectory = [ (baseNameOf dataDir) ];
        User = "${cfg.user}";
      };
      startAt = "hourly";
      after = [ "selfoss-config.service" ];
      wantedBy = [ "multi-user.target" ];

    };

  };
}
