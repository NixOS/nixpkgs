{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.postgresqlBackup;

  postgresqlBackupService = db: dumpCmd:
    {
      enable = true;

      description = "Backup of ${db} database(s)";

      requires = [ "postgresql.service" ];

      script = ''
        umask 0077 # ensure backup is only readable by postgres user

        if [ -e ${cfg.location}/${db}.sql.gz ]; then
          ${pkgs.coreutils}/bin/mv ${cfg.location}/${db}.sql.gz ${cfg.location}/${db}.prev.sql.gz
        fi

        ${dumpCmd} | \
          ${pkgs.gzip}/bin/gzip -c > ${cfg.location}/${db}.sql.gz
      '';

      serviceConfig = {
        Type = "oneshot";
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

      backupAll = mkOption {
        default = cfg.databases == [];
        defaultText = "services.postgresqlBackup.databases == []";
        type = lib.types.bool;
        description = ''
          Backup all databases using pg_dumpall.
          This option is mutual exclusive to
          <literal>services.postgresqlBackup.databases</literal>.
          The resulting backup dump will have the name all.sql.gz.
          This option is the default if no databases are specified.
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
          Command line options for pg_dump. This options is not used
          if <literal>config.services.postgresqlBackup.backupAll</literal> is enabled.
          Note that config.services.postgresqlBackup.backupAll is also active,
          when no databases where specified.
        '';
      };
    };

  };

  config = mkMerge [
    {
      assertions = [{
        assertion = cfg.backupAll -> cfg.databases == [];
        message = "config.services.postgresqlBackup.backupAll cannot be used together with config.services.postgresqlBackup.databases";
      }];
    }
    (mkIf cfg.enable {
      systemd.tmpfiles.rules = [
        "d '${cfg.location}' 0700 postgres - - -"
      ];
    })
    (mkIf (cfg.enable && cfg.backupAll) {
      systemd.services.postgresqlBackup =
        postgresqlBackupService "all" "${config.services.postgresql.package}/bin/pg_dumpall";
    })
    (mkIf (cfg.enable && !cfg.backupAll) {
      systemd.services = listToAttrs (map (db:
        let
          cmd = "${config.services.postgresql.package}/bin/pg_dump ${cfg.pgdumpOptions} ${db}";
        in {
          name = "postgresqlBackup-${db}";
          value = postgresqlBackupService db cmd;
        }) cfg.databases);
    })
  ];

}
