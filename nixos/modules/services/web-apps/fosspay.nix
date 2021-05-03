{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.fosspay;

  package = pkgs.fosspay.override { conf = "${stateDir}/config.ini"; };
  format = pkgs.formats.ini {};
  stateDir = "/var/lib/fosspay";
  configFile = format.generate "config.ini" cfg.settings;
in
{
  options.services.fosspay = {
    enable = lib.mkEnableOption "Donation collection for FOSS groups and individuals.";

    secretKeyFile = lib.mkOption {
      type = lib.types.path;
      example = "/run/keys/fosspay-secret-key";
      description = ''
        A file containing a key for use with fosspay.
      '';
    };

    database = {
      connectionString = mkOption {
        type = types.str;
        default = "postgresql:///fosspay";
        description = "URI for connecting to database";
      };

      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Create the database and database user locally.";
      };
    };

    settings = lib.mkOption {
      type = format.type;
      default = {};
      example = literalExample ''
        dev = {
          protocol = "http";
          domain = "localhost:5000";

          your-name = "Joe Bloe";
          your-email = "joe@example.org";

          currency = "usd";
          default-amounts = "3 5 10 20";
          default-amount = 5;
          default-type = "monthly";
          public-income = true;
          goal = 500;
        };
      '';
      description = ''
        fosspay configuration. Refer to
        <link xlink:href="https://git.sr.ht/~sircmpwn/fosspay/blob/master/config.ini.example"/>
        for details on supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fosspay = {
      description = "fosspay website";
      wantedBy = [ "multi-user.target" ];
      after = lib.optionals cfg.database.createLocally [ "postgresql.service" ];
      bindsTo = lib.optionals cfg.database.createLocally [ "postgresql.service" ];

      preStart = ''
        cp -f ${configFile} ${stateDir}/config.ini
        chmod 640 ${stateDir}/config.ini

        # insert our secret files into config.ini that we'll use
        ${pkgs.crudini}/bin/crudini --set ${stateDir}/config.ini dev secret-key "$(head -n1 ${cfg.secretKeyFile})"
      '' + lib.optionals cfg.database.createLocally ''
        ${pkgs.crudini}/bin/crudini --set ${stateDir}/config.ini dev connection-string "${cfg.database.connectionString}"
      '';

      serviceConfig = {
        User = "fosspay";
        Group = "fosspay";
        StateDirectory = "fosspay";
        StateDirectoryMode = "0700";
        WorkingDirectory = "${package}/share";
        ExecStart = "${package}/bin/gunicorn app:app -b 127.0.0.1:5000";
        ExecStop = "${pkgs.busybox}/bin/pkill gunicorn";
      };
    };

    services.postgresql = lib.optionalAttrs cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "fosspay" ];

      # auth needs to be set to trust if we want do connect locally without password
      # I couldn't find any other example of setting up passwordless connection with psycopg2
      authentication = ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';

      ensureUsers = [
        {
          name = "fosspay";
          ensurePermissions = { "DATABASE fosspay" = "ALL PRIVILEGES"; };
        }
      ];
    };

    users.users = {
      fosspay = {
        isSystemUser = true;
        group = "fosspay";
      };
    };

    users.groups = {
      fosspay = {};
    };
  };
}
