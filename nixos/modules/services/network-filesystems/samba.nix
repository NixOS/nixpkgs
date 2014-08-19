{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.samba;

  user = "smbguest";
  group = "smbguest";

  logDir = "/var/log/samba";
  privateDir = "/var/samba/private";

  inherit (pkgs) samba;

  setupScript =
    ''
      if ! test -d /home/smbd ; then
        mkdir -p /home/smbd
        chown ${user} /home/smbd
        chmod a+rwx /home/smbd
      fi

      if ! test -d /var/samba ; then
        mkdir -p /var/samba/locks /var/samba/cores/nmbd  /var/samba/cores/smbd /var/samba/cores/winbindd
      fi

      passwdFile="$(${pkgs.gnused}/bin/sed -n 's/^.*smb[ ]\+passwd[ ]\+file[ ]\+=[ ]\+\(.*\)/\1/p' ${configFile})"
      if [ -n "$passwdFile" ]; then
        echo 'INFO: [samba] creating directory containing passwd file'
        mkdir -p "$(dirname "$passwdFile")"
      fi

      mkdir -p ${logDir}
      mkdir -p ${privateDir}
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

  # This may include nss_ldap, needed for samba if it has to use ldap.
  nssModulesPath = config.system.nssModules.path;

  daemonService = appName: args:
    { description = "Samba Service Daemon ${appName}";

      requiredBy = [ "samba.target" ];
      partOf = [ "samba.target" ];

      environment = {
        LD_LIBRARY_PATH = nssModulesPath;
        LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
      };

      serviceConfig = {
        ExecStart = "${samba}/sbin/${appName} ${args}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };

      restartTriggers = [ configFile ];
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

      nsswins = mkOption {
        default = false;
        type = types.uniq types.bool;
        description = ''
          Whether to enable the WINS NSS (Name Service Switch) plug-in.
          Enabling it allows applications to resolve WINS/NetBIOS names (a.k.a.
          Windows machine names) by transparently querying the winbindd daemon.
        '';
      };

    };

  };


  ###### implementation

  config = mkMerge
    [ { # Always provide a smb.conf to shut up programs like smbclient and smbspool.
        environment.etc = singleton
          { source =
              if cfg.enable then configFile
              else pkgs.writeText "smb-dummy.conf" "# Samba is disabled.";
            target = "samba/smb.conf";
          };
      }

      (mkIf config.services.samba.enable {

        users.extraUsers.smbguest = {
          description = "Samba service user";
          group = group;
          uid = config.ids.uids.smbguest;
        };

        users.extraGroups.smbguest.gid = config.ids.uids.smbguest;

        system.nssModules = optional cfg.nsswins samba;

        systemd = {
          targets.samba = {
            description = "Samba Server";
            requires = [ "samba-setup.service" ];
            after = [ "samba-setup.service" "network.target" ];
            wantedBy = [ "multi-user.target" ];
          };

          services = {
            "samba-nmbd" = daemonService "nmbd" "-F";
            "samba-smbd" = daemonService "smbd" "-F";
            "samba-winbindd" = daemonService "winbindd" "-F";
            "samba-setup" = {
              description = "Samba Setup Task";
              script = setupScript;
              unitConfig.RequiresMountsFor = "/home/smbd /var/samba /var/log/samba";
            };
          };
        };

        security.pam.services.sambda = {};

      })
    ];

}
