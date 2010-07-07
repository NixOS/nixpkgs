{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.samba;
  
  user = "smbguest";
  group = "smbguest";

  logDir = "/var/log/samba";
  privateDir = "/var/samba/private";
 
  inherit (pkgs) samba;

  setupScript =
    ''
      mkdir -p /var/lock

      if ! test -d /home/smbd ; then
        mkdir -p /home/smbd
        chown ${user} /home/smbd
        chmod a+rwx /home/smbd
      fi

      if ! test -d /var/samba ; then
        mkdir -p /var/samba/locks /var/samba/cores/nmbd  /var/samba/cores/smbd /var/samba/cores/winbindd
      fi

      passwdFile="$(sed -n 's/^.*smb[ ]\+passwd[ ]\+file[ ]\+=[ ]\+\(.*\)/\1/p' ${configFile})"
      if [ -n "$passwdFile" ]; then
        echo 'INFO: creating directory containing passwd file'
        mkdir -p "$(dirname "$passwdFile")"
      fi

      mkdir -p ${logDir}
      mkdir -p ${privateDir}

      # The following line is to trigger a restart of the daemons when
      # the configuration changes:
      # ${configFile}
    '';

  configFile = pkgs.writeText "smb.conf"
    ''
      [ global ]
      log file = ${logDir}/log.%m
      private dir = ${privateDir}
      ${optionalString cfg.syncPasswordsByPam "pam password change = true"}

      ${if cfg.defaultShare.enable then ''
      [default]
      path = /home/smbd
      read only = ${if cfg.defaultShare.writeable then "no" else "yes"}
      guest ok = ${if cfg.defaultShare.guest then "yes" else "no"}
      ''else ""}

      ${cfg.extraConfig}
    '';

  daemonJob = appName: args:
    { name = "samba-${appName}";
      description = "Samba Service daemon ${appName}";

      startOn = "started samba";
      stopOn = "stopping samba";

      exec = "${samba}/sbin/${appName} ${args}";
    };

in

{

  ###### interface

  options = {

    # !!! clean up the descriptions.
  
    services.samba = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable Samba, which provides file and print
          services to Windows clients through the SMB/CIFS protocol.
        ";
      };

      syncPasswordsByPam = mkOption {
        default = false;
        description = "
          enabling this will add a line directly after pam_unix.so.
          Whenever a password is changed the samba password will be updated as well.
          However you still yave to add the samba password once using smbpasswd -a user
          If you don't want to maintain an extra pwd database you still can send plain text
          passwords which is not secure.
        ";
      };

      extraConfig = mkOption {
        # !!! Bad default.
        default = ''
          # [global] continuing global section here, section is started by nix to set pids etc

            smb passwd file = /etc/samba/passwd

            # is this useful ?
            domain master = auto

            encrypt passwords = Yes
            client plaintext auth = No

            # yes: if you use this you probably also want to enable syncPasswordsByPam
            # no: You can still use the pam password database. However
            # passwords will be sent plain text on network (discouraged)

            workgroup = Users
            server string = %h
            comment = Samba
            log file = /var/log/samba/log.%m
            log level = 10
            max log size = 50000
            security = ${cfg.securityType}

            client lanman auth = Yes
            dns proxy = no
            invalid users = root
            passdb backend = tdbsam
            passwd program = /usr/bin/passwd %u
        '';

        description = "
          additional global section and extra section lines go in here.
        ";
      };

      configFile = mkOption {
        description = "
          internal use to pass filepath to samba pam module
        ";
      };

      defaultShare = {
        enable = mkOption {
	  description = "Whether to share /home/smbd as 'default'.";
	  default = false;
	};
        writeable = mkOption {
	  description = "Whether to allow write access to default share.";
	  default = false;
	};
        guest = mkOption {
	  description = "Whether to allow guest access to default share.";
	  default = true;
	};
      };

      securityType = mkOption {
        description = "Samba security type";
	default = "user";
	example = "share";
      };

    };

  };
  

  ###### implementation

  config = mkIf config.services.samba.enable {

    users.extraUsers = singleton
      { name = user;
        description = "Samba service user";
        group = group;
      };

    users.extraGroups = singleton
      { name = group;
      };

    # always provide a smb.conf to shut up programs like smbclient and smbspool.
    environment.etc = mkAlways (singleton
      { source =
          if cfg.enable then configFile
          else pkgs.writeText "smb-dummy.conf" "# Samba is disabled.";
        target = "samba/smb.conf";
      });

    # Dummy job to start the real Samba daemons (nmbd, smbd, winbindd).
    jobs.sambaControl =
      { name = "samba";
        description = "Samba server";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        preStart = setupScript;
      };

    # nmbd says "standard input is not a socket, assuming -D option",
    # but using -i makes it stay in foreground (?)
    jobs.nmbd = daemonJob "nmbd" " -i -F";

    jobs.smbd = daemonJob "smbd" " -i -F";

    jobs.winbindd = daemonJob "winbindd" " -F";

  };
  
}
