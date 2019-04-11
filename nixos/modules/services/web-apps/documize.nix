{ pkgs, lib, config, ... }:

with lib;

let

  cfg = config.services.documize;

in

  {
    options.services.documize = {
      enable = mkEnableOption "Documize Wiki";

      offline = mkEnableOption "Documize offline mode";

      package = mkOption {
        default = pkgs.documize-community;
        type = types.package;
        description = ''
          Which package to use for documize.
        '';
      };

      db = mkOption {
        type = types.str;
        example = "host=localhost port=5432 sslmode=disable user=admin password=secret dbname=documize";
        description = ''
          The DB connection string to use for the database.
        '';
      };

      dbtype = mkOption {
        type = types.enum [ "postgresql" "percona" "mariadb" "mysql" ];
        description = ''
          Which database to use for storage.
        '';
      };

      port = mkOption {
        type = types.port;
        example = 3000;
        description = ''
          Which TCP port to serve.
        '';
      };
    };

    config = mkIf cfg.enable {
      systemd.services.documize-server = {
        wantedBy = [ "multi-user.target" ];

        script = ''
          ${cfg.package}/bin/documize \
            -db "${cfg.db}" \
            -dbtype ${cfg.dbtype} \
            -port ${toString cfg.port} \
            -offline ${if cfg.offline then "1" else "0"}
        '';

        serviceConfig = {
          Restart = "always";
          DynamicUser = "yes";
        };
      };
    };
  }
