{ config, lib, pkgs, ... }:

let
  cfg = config.services.acts;
  cfgFile = pkgs.writeText "acts.conf" ''
    #!/bin/sh
    backuptargets="${concatStringsSep " " cfg.backupTargets}"

    # tarsnap
    # What command to call for 'tarsnap'.
    # Default: tarsnap
    tarsnap="nice -n19 ionice -c3 tarsnap"

    # tarsnapbackupoptions
    # What options to use when backing up.
    # e.g.: --one-file-system --humanize-numbers
    # Note: this variable will be expanded by /bin/sh.
    # Default: unset
    tarsnapbackupoptions="--one-file-system --humanize-numbers"

    # verbose
    # Log verbosity. Output is written to stderr.
    # -1 silent. 0=normal. 1=verbose. 2=debug.
    # Default: 0
    verbose=1

    # hostname
    # The machine name prefixed to created archives.
    # Default: $(hostname -s)
    #hostname=$(hostname)

    # uselocaltime
    # Use local time instead of UTC for the archive date and timestamps.
    # Default: 0 (i.e. use UTC)
    #uselocaltime=1

    # prebackupscript
    # This script is run before backups are created. Make sure it's executable.
    # Default: unset
    #prebackupscript=/root/acts-pre.sh

    # postbackupscript
    # This script is run after acts is otherwise finished. Make sure it's executable.
    # Default: unset
    #postbackupscript=/root/acts-post.sh

    # syslog
    # If set, log output will be written to syslog with the given facility.
    # eg, user, local0, ...
    # Default: unset
    #syslog=user

    # lockfile
    # Where acts should write its lockfile.
    # Default: /var/run/acts
    #lockfile=/tmp/acts
  '';
  pkg = pkgs.acts;
  user = "acts";
  group = "acts";

  inherit (lib) concatStringsSep mkEnableOption mkIf mkOption types;
in
  {
    # interface
    options = {
      services.acts = {
        enable = mkEnableOption "acts";

        backupTargets = mkOption {
          type = types.listOf types.str;
          example = [ "var" "etc" "home" "root" ];
          description = ''
            Space-separated list of directories to backup, relative to /.
          '';
        };

        calendar = mkOption {
          type = types.str;
          default = "daily";
          description = ''
            Configures when to run the backups using systemd.time syntax
          '';
        };
      };
    };

    # implementation
    config = mkIf cfg.enable {
      systemd.services.acts = {
        description= "acts tarsnap backup service";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkg}/bin/acts ${cfgFile}";
        };
      };

      systemd.timers.acts = {
        description = "acts timer";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.calendar;
          Persistent = "true";
        };
      };
    };
  }
