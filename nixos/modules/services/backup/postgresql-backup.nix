{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.postgresqlBackup;

  postgresqlBackupService = db: {
    description = "Backup of database ${db}";
    enable = true;
    requires = [ "postgresql.service" ];
    startAt = cfg.startAt;

    preStart = ''
      mkdir -m 0700 -p ${cfg.location}
      chown postgres ${cfg.location}
    '';

    script = ''
      # Use the same PATH as the PostgreSQL instance, as it's configured
      # with plugins and extensions. This is a bit of a hack; we can't easily
      # set the nixos systemd options to do this, because the path is already
      # constructed and is too long by the time the systemd.nix module examines
      # it
      export PATH="${config.systemd.services.postgresql.environment.PATH}"

      if [ -e ${cfg.location}/${db}.sql.gz ]; then
        mv ${cfg.location}/${db}.sql.gz ${cfg.location}/${db}.prev.sql.gz
      fi

      pg_dump ${cfg.pgdumpOptions} ${db} | ${pkgs.gzip}/bin/gzip -c > ${cfg.location}/${db}.sql.gz
    '';

    serviceConfig = {
      Type = "oneshot";
      PermissionsStartOnly = "true";
      User = "postgres";
    };
  };

in {
  options = {
    services.postgresqlBackup = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable PostgreSQL dumps.
        '';
      };

      startAt = mkOption {
        default = "*-*-* 01:15:00";
        description = ''
          This option defines (see <literal>systemd.time</literal> for format) when the
          databases should be dumped.
          The default is to update at 01:15 (at night) every day.
        '';
      };

      databases = mkOption {
        default = [];
        description = ''
          List of database names to dump.
        '';
      };

      location = mkOption {
        default = "/var/backup/postgresql";
        description = ''
          Location to put the gzipped PostgreSQL database dumps.
        '';
      };

      pgdumpOptions = mkOption {
        type = types.string;
        default = "-Cbo";
        description = ''
          Command line options for pg_dump.
        '';
      };
    };
  };

  config = mkIf config.services.postgresqlBackup.enable {

    systemd.services = listToAttrs (map (db: {
      name = "postgresqlBackup-${db}";
      value = postgresqlBackupService db;
    }) cfg.databases);

  };
}
