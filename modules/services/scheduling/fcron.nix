{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption concatStringsSep;
  inherit (pkgs) writeText;

  options = {
    services = {
      fcron = {
        enable = mkOption {
          default = false;
          description = ''Whether to enable the `fcron' daemon.
            From its docs: "fcron does both the job of Vixie Cron and anacron, but does even more and better".
            It can trigger actions even if the event has passed due to shutdown for example.
            TODO: add supoprt for fcron.allow and fcron.deny
            Of course on cron daemon is enough.. So if fcron works fine there should be a system option systemCron="fcron or cron"

            There are (or have been) some security issues.
            I haven't yet checked wether they have been resolved.
            For now you should trust the users registering crontab files.
            I think gentoo has them listed.
          '';
        };
        allow = mkOption {
          default = [];
          description = ''
            Users allowed to use fcrontab and fcrondyn (one name per line, special name "all" acts for everyone)
            nix adds username "root" for you.
          '';
        };
        deny = mkOption {
          default = [];
          description = " same as allow but deny ";
        };
        maxSerialJobs = mkOption {
          default = 1;
          description = "maximum number of serial jobs which can run simultaneously (-m)";
        };
        queuelen = mkOption {
          default = "";
          description = "number of jobs the serial queue and the lavg queue can contain - empty to net set this number (-q)";
        };
        systab = mkOption {
          default = "";
          description = ''
            The "system" crontab contents..
          '';
        };
      };
    };
  };
in

###### implementation
let
  # Put all the system cronjobs together.
  # TODO allow using fcron only..
  #systemCronJobs =
  #  config.services.cron.systemCronJobs;
  cfg = config.services.fcron;
  ifEnabled = if cfg.enable then pkgs.lib.id else (x : []);
  queuelen = if cfg.queuelen == "" then "" else "-q ${toString cfg.queuelen}";

  # shell is set to /sh in config..
  # ${pkgs.lib.concatStrings (map (job: job + "\n") systemCronJobs)}
  systemCronJobsFile = pkgs.writeText "fcron-systab" ''
    SHELL=${pkgs.bash}/bin/sh
    PATH=${pkgs.coreutils}/bin:${pkgs.findutils}/bin:${pkgs.gnused}/bin
  '';

  allowdeny = target: users : {
    source = writeText "fcron.${target}" (concatStringsSep "\n" users);
    target = "fcron.${target}";
    mode = "600"; # fcron has some security issues.. So I guess this is most safe
  };

in

{
  require = [
    # ../upstart-jobs/default.nix # config.services.extraJobs
    # ? # config.time.timeZone
    # ? # config.environment.etc
    # ? # config.environment.extraPackages
    # ? # config.environment.cleanStart
    options
  ];

  environment = {
    etc = ifEnabled [
      (allowdeny "allow" (["root"] ++ cfg.allow))
      (allowdeny "deny" cfg.deny)
      # see man 5 fcron.conf
      { source = writeText "fcon.conf" ''
          fcrontabs	=	/var/spool/fcron
          pidfile	=	/var/run/fcron.pid
          fifofile	=	/var/run/fcron.fifo
          fcronallow	=	/etc/fcron.allow
          fcrondeny	=	/etc/fcron.deny
          shell		=	/bin/sh
          sendmail	=	/var/setuid-wrappers/sendmail
          editor	=	/var/run/current-system/sw/bin/vi
       '';
        target = "fcron.conf";
        mode = "0600"; # max allowed is 644
      }
    ];

    systemPackages = ifEnabled [pkgs.fcron];
  };

  services = {
    extraJobs = ifEnabled [{
      name = "fcron";

      job = ''
        description "fcron daemon"

        start on startup
        stop on shutdown

        env PATH=/var/run/current-system/sw/bin

        start script
            ${pkgs.coreutils}/bin/mkdir -m 0700 -p /var/spool/fcron
            # load system crontab file
            ${pkgs.fcron}/bin/fcrontab -u systab ${writeText "systab" cfg.systab}
        end script

        respawn ${pkgs.fcron}/sbin/fcron -f -m ${toString cfg.maxSerialJobs} ${queuelen}
      '';
    }];
  };
}
