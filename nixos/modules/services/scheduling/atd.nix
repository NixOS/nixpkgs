{ config, lib, pkgs, ... }:

with lib;

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

    # Not wrapping "batch" because it's a shell script (kernel drops perms
    # anyway) and it's patched to invoke the "at" setuid wrapper.
    security.wrappers = builtins.listToAttrs (
      map (program: { name = "${program}"; value = {
      source = "${at}/bin/${program}";
      owner = "atd";
      group = "atd";
      setuid = true;
      setgid = true;
    };}) [ "at" "atq" "atrm" ]);

    environment.systemPackages = [ at ];

    security.pam.services.atd = {};

    users.users.atd =
      { uid = config.ids.uids.atd;
        description = "atd user";
        home = "/var/empty";
      };

    users.groups.atd.gid = config.ids.gids.atd;

    systemd.services.atd = {
      description = "Job Execution Daemon (atd)";
      after = [ "systemd-udev-settle.service" ];
      wants = [ "systemd-udev-settle.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ at ];

      preStart = ''
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

      script = "atd";

      serviceConfig.Type = "forking";
    };
  };
}
