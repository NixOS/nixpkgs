{pkgs, config, ...}:

with pkgs.lib;

let

  cfg = config.services.atd;

  inherit (pkgs) at;

in

{

  ###### interface

  options = {

    services.atd.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the <command>at</command> daemon, a command scheduler.
      '';
    };

    services.atd.allowEveryone = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to make <filename>/var/spool/at{jobs,spool}</filename>
        writeable by everyone (and sticky).  This is normally not
        needed since the <command>at</command> commands are
        setuid/setgid <literal>atd</literal>.
     '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    security.setuidOwners = map (program: {
      inherit program;
      owner = "atd";
      group = "atd";
      setuid = true;
      setgid = true;
    }) [ "at" "atq" "atrm" "batch" ];

    environment.systemPackages = [ at ];

    security.pam.services.atd = {};

    users.extraUsers = singleton
      { name = "atd";
        uid = config.ids.uids.atd;
        description = "atd user";
        home = "/var/empty";
      };

    users.extraGroups = singleton
      { name = "atd";
        gid = config.ids.gids.atd;
      };

    jobs.atd =
      { description = "Job Execution Daemon (atd)";

        startOn = "stopped udevtrigger";

        path = [ at ];

        preStart =
          ''
            # Snippets taken and adapted from the original `install' rule of
            # the makefile.

            # We assume these values are those actually used in Nixpkgs for
            # `at'.
            spooldir=/var/spool/atspool
            jobdir=/var/spool/atjobs
            etcdir=/etc/at

            for dir in "$spooldir" "$jobdir" "$etcdir"; do
              if [ ! -d "$dir" ]; then
                  mkdir -p "$dir"
                  chown atd:atd "$dir"
              fi
            done
            chmod 1770 "$spooldir" "$jobdir"
            ${if cfg.allowEveryone then ''chmod a+rwxt "$spooldir" "$jobdir" '' else ""}
            if [ ! -f "$etcdir"/at.deny ]; then
                touch "$etcdir"/at.deny
                chown root:atd "$etcdir"/at.deny
                chmod 640 "$etcdir"/at.deny
            fi
            if [ ! -f "$jobdir"/.SEQ ]; then
                touch "$jobdir"/.SEQ
                chown atd:atd "$jobdir"/.SEQ
                chmod 600 "$jobdir"/.SEQ
            fi
          '';

        exec = "atd";

        daemonType = "fork";
      };

  };

}
