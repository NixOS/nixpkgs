{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.borgbackup;

  makeService = name: jobcfg: {
    description = "Borgbackup job ${name}";
    path = with pkgs; [ openssh ];
    environment = {
      "BORG_REPO" = jobcfg.repository;
      "BORG_PASSPHRASE" = jobcfg.passphrase or "";
    };
    preStart = jobcfg.preBackup;
    script = ''
      echo Running borg create
      ${pkgs.borgbackup}/bin/borg create -v \
        --stats \
        --exclude-from ${pkgs.writeText "borgbackup-${name}-excludes" (
          concatStringsSep "\n" jobcfg.excludes
        )} \
        --compression ${jobcfg.compression} \
        ::${jobcfg.archive} '${concatStringsSep "' '" jobcfg.paths}'
    '' + optionalString jobcfg.prune.enable (
      let
        keepCfg = jobcfg.prune.keep;
        cmdOption = ktype:
          let t = keepCfg."${ktype}"; in
          optionalString (t != null) " --keep-${ktype} '${t}' ";
      in ''
        echo Running borg prune
        ${pkgs.borgbackup}/bin/borg prune -v ''
          + cmdOption "within"
          + cmdOption "hourly"
          + cmdOption "daily"
          + cmdOption "weekly"
          + cmdOption "monthly"
          + cmdOption "yearly"
          + '' \
        --stats
      ''
    );
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
      User = "borg";
      Group = jobcfg.group;
      PermissionsStartOnly = true;
      TimeoutStartSec = "2h";
      TimeoutSec = "6h";
    };
  };

  makeTimer = name: jobcfg: {
    description = "Update timer for borgbackup job ${name}";
    partOf      = [ "borgbackup-${name}.service" ];
    wantedBy    = [ "timers.target" ];
    timerConfig.OnCalendar = jobcfg.interval;
  };

in

{
  options = {
    services.borgbackup.jobs = mkOption {
      default = {};
      description = "Borgbackup jobs.";
      type = types.attrsOf (types.submodule {
        options = {
          repository = mkOption {
            type = types.str;
            example = "user@hostname:backup";
            description = ''
              Path to borg repository.
            '';
          };

          archive = mkOption {
            type = types.str;
            default = "{hostname}-{now:%Y-%m-%d-%H-%M}";
            example = "{hostname}-{user}-{now:%Y-%m-%d-%H-%M}";
            description = ''
              Archive name pattern for individual backups.

              The format is described in
              <citerefentry><refentrytitle>borg</refentrytitle>
              <manvolnum>1</manvolnum></citerefentry>.
            '';
          };

          paths = mkOption {
            type = types.listOf types.str;
            default = [];
            example = [ "/var/backups" "/etc/nixos" ];
            description = ''
              List of paths or path patterns to backup.
            '';
          };

          group = mkOption {
            type = types.str;
            default = "backup";
            description = ''
              Passphrase to use for encrypted repositories, if any.
            '';
          };

          passphrase = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Passphrase to use for encrypted repositories, if any.
            '';
          };

          compression = mkOption {
            type = types.str;
            default = "lz4";
            example = "lzma,1";
            description = ''
              Compression method to use for backups.

              The format is described in
              <citerefentry><refentrytitle>borg</refentrytitle>
              <manvolnum>1</manvolnum></citerefentry>.
            '';
          };

          excludes = mkOption {
            type = types.listOf types.str;
            default = [];
            example = [ "*.pyc" "*.o" ];
            description = ''
              Patterns for paths to exclude from backups.

              The format is described in
              <citerefentry><refentrytitle>borg</refentrytitle>
              <manvolnum>1</manvolnum></citerefentry>.
            '';
          };

          prune.enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to prune the respository after creating a backup.
            '';
          };

          prune.prefix = mkOption {
            type = types.str;
            default = ''''${config.networking.hostname}-'';
            example = "hostname-";
            description = ''
              Prefix of archives in the repository to prune.
            '';
          };

          prune.keep.within = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "10d";
            description = "How long to keep backups.";
          };

          prune.keep.hourly = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "24";
            description = "How many backups to keep per hour.";
          };

          prune.keep.daily = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "7";
            description = "How many backups to keep per day.";
          };

          prune.keep.weekly = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "4";
            description = "How many backups to keep per week.";
          };

          prune.keep.monthly = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "12";
            description = "How many backups to keep per month.";
          };

          prune.keep.yearly = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "5";
            description = "How many backups to keep per year.";
          };

          preBackup = mkOption {
            type = types.lines;
            default = "";
            description = "Script to execute before the backup job.";
          };

          interval = mkOption {
            type = types.str;
            default = "daily";
            example = "hourly";
            description = ''
              When to run borg create backup job.

              The format is described in
              <citerefentry><refentrytitle>systemd.time</refentrytitle>
              <manvolnum>7</manvolnum></citerefentry>.
            '';
          };
        };
      });
    };
  };

  config = mkIf (cfg.jobs != {}) (
    let
      mapJobs = f: listToAttrs (mapAttrsFlatten f cfg.jobs);
    in {
      assertions = mapAttrsToList (name: value: {
        assertion = cfg.jobs."${name}".paths != [];
        message = "services.borgbackup.jobs.${name}.paths can't be an empty list";
      }) cfg.jobs;

      users.extraUsers = singleton {
        name = "borg";
        group = "backup";
        isNormalUser = true;
        description = "borg backup user";
        home = "/var/backup";
      };

      users.extraGroups = singleton {
        name = "backup";
      };

      systemd.services = mapJobs (name: value: nameValuePair "borgbackup-${name}" (makeService name value));

      systemd.timers = mapJobs (name: value: nameValuePair "borgbackup-${name}" (makeTimer name value));

      environment.systemPackages = [ pkgs.borgbackup ];
    }
  );
}
