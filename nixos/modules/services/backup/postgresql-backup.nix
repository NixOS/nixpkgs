{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.postgresqlBackup;

  postgresqlBackupService = db :
    {
      enable = true;

      description = "Backup of database ${db}";

      requires = [ "postgresql.service" ];

      preStart = ''
        mkdir -m 0700 -p ${cfg.location}
        chown postgres ${cfg.location}
      '';

      script = ''
        umask 0077 # ensure backup is only readable by postgres user

        if [ -e ${cfg.location}/${db}.sql.gz ]; then
          ${pkgs.coreutils}/bin/mv ${cfg.location}/${db}.sql.gz ${cfg.location}/${db}.prev.sql.gz
        fi

        ${config.services.postgresql.package}/bin/pg_dump ${cfg.pgdumpOptions} ${db} | \
          ${pkgs.gzip}/bin/gzip -c > ${cfg.location}/${db}.sql.gz
      '';

      serviceConfig = {
        Type = "oneshot";
        PermissionsStartOnly = "true";
        User = "postgres";
      };

      startAt = cfg.startAt;
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

    systemd.services = listToAttrs (map (db : {
          name = "postgresqlBackup-${db}";
          value = postgresqlBackupService db; } ) cfg.databases);
  };

}
