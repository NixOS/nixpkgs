{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.duplicityBackup;

  cfgPackage = pkgs.duplicity-backup-sh;

  duplicityBackupConfig = cfg: ''
    ROOT="${cfg.root}"
    DEST="${cfg.destination}"
    ${optionalString (cfg.include != []) ''INCLIST=(
      ${concatMapStringsSep " " (x: ''"${x}"'') cfg.include}
    )''}
    ${optionalString (cfg.exclude != []) ''EXCLIST=(
      ${concatMapStringsSep " " (x: ''"${x}"'') cfg.exclude}
    )''}
    ENCRYPTION="${if cfg.encryption.enable
      then "yes" else "no"
    }"
    ${optionalString cfg.encryption.enable ''
      PASSPHRASE="${cfg.encryption.passphrase}"
    ''}
    CLEAN_UP_TYPE="${if cfg.cleanup.enable then cfg.cleanup.type else "none"}"
    ${optionalString cfg.cleanup.enable '' 
      CLEAN_UP_VARIABLE="${cfg.cleanup.var}"
    ''}
    HOSTNAME=${config.networking.hostName}
    STATIC_OPTIONS="${cfg.options}"
    LOGDIR="/var/log/duplicity-backup/"
    LOG_FILE="duplicity-$(date +%Y-%m-%d_%H-%M).txt"
    VERBOSITY="-v3"
    ${cfg.extraConfig}
  '';

in {

  options = {
    services.duplicityBackup = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Duplicity.
        '';
      };

      onCalendar = mkOption {
        type = types.str;
        default = "02:00";
        description = ''
          Create backup on given date/time/interval, which must be in the
          format described in
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
        '';
      };

      options = mkOption {
        type = types.str;
        default = "";
        description = "Options to run duplicity with.";
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Extra configuration.";
      };

      root = mkOption {
        type = types.str;
        description = "Root-directory to backups.";
      };

      destination = mkOption {
        type = types.str;
        description = "Destination to store backups at.";
      };

      include = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of directories to include.
          Include everything if empty.
        '';
      };

      exclude = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of directories to exclude.";
      };

      encryption = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to enable encryption.";
        };
        passphrase = mkOption {
          type = types.str;
          description = "Passphrase used for encryption.";
        };
      };

      cleanup = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to cleanup old backups.";
        };
        type = mkOption {
          type = types.str;
          default = "remove-all-but-n-full";
          description = "CLEAN_UP_TYPE";
        };
        var = mkOption {
          type = types.str;
          default = "4";
          description = "CLEAN_UP_VARIABLE";
        };
      };
    };
  };

  config = mkIf cfg.enable {

    environment.etc = [
      {
        source = pkgs.writeTextFile {
          name = "duplicity-backup.conf";
          text = (duplicityBackupConfig cfg);
        };
        target = "duplicity-backup.conf";
        mode = "0400";
      }
    ];

    system.activationScripts.duplicity-backup = stringAfter [
      "stdio" "users"
    ] ''
      mkdir -m 0700 -p /var/log/duplicity-backup
      chown root /var/log/duplicity-backup
    '';

    systemd.services.duplicity-backup = {
      description = "Incremental Backup using duplicity-backup.sh";
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        PermissionsStartOnly = true;
      };
      script = ''
        ${cfgPackage}/bin/duplicity-backup.sh \
          -c /etc/duplicity-backup.conf \
          --backup
      '';
    };

    systemd.timers.duplicity-backup = {
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        Unit = "duplicity-backup.service";
        OnCalendar = cfg.onCalendar;
        Persistent = "true";
      };
    };
  };

}
