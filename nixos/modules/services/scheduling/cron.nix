{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (config.services) jobsTags;

  # Put all the system cronjobs together.
  systemCronJobsFile = pkgs.writeText "system-crontab"
    ''
      SHELL=${pkgs.bash}/bin/bash
      PATH=${config.system.path}/bin:${config.system.path}/sbin
      ${optionalString (config.services.cron.mailto != null) ''
        MAILTO="${config.services.cron.mailto}"
      ''}
      NIX_CONF_DIR=/etc/nix
      ${pkgs.lib.concatStrings (map (job: job + "\n") config.services.cron.systemCronJobs)}
    '';

  # Vixie cron requires build-time configuration for the sendmail path.
  cronNixosPkg = pkgs.cron.override {
    # The mail.nix nixos module, if there is any local mail system enabled,
    # should have sendmail in this path.
    sendmailPath = "/var/setuid-wrappers/sendmail";
  };

in

{

  ###### interface

  options = {

    services.cron = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable the Vixie cron daemon.";
      };

      mailto = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Email address to which job output will be mailed.";
      };

      systemCronJobs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = literalExample ''
          [ "* * * * *  test   ls -l / > /tmp/cronout 2>&1"
            "* * * * *  eelco  echo Hello World > /home/eelco/cronout"
          ]
        '';
        description = ''
          A list of Cron jobs to be appended to the system-wide
          crontab.  See the manual page for crontab for the expected
          format. If you want to get the results mailed you must setuid
          sendmail. See <option>security.setuidOwners</option>

          If neither /var/cron/cron.deny nor /var/cron/cron.allow exist only root
          will is allowed to have its own crontab file. The /var/cron/cron.deny file
          is created automatically for you. So every user can use a crontab.

          Many nixos modules set systemCronJobs, so if you decide to disable vixie cron
          and enable another cron daemon, you may want it to get its system crontab
          based on systemCronJobs.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.cron.enable {

    environment.etc = singleton
      # The system-wide crontab.
      { source = systemCronJobsFile;
        target = "crontab";
        mode = "0600"; # Cron requires this.
      };

    security.setuidPrograms = [ "crontab" ];

    environment.systemPackages = [ cronNixosPkg ];

    jobs.cron =
      { description = "Cron Daemon";

        startOn = "startup";

        path = [ cronNixosPkg ];

        preStart =
          ''
            mkdir -m 710 -p /var/cron

            # By default, allow all users to create a crontab.  This
            # is denoted by the existence of an empty cron.deny file.
            if ! test -e /var/cron/cron.allow -o -e /var/cron/cron.deny; then
                touch /var/cron/cron.deny
            fi
          '';

        exec = "cron -n";
      };

  };

}
