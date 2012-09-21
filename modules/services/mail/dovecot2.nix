{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.dovecot2;

  dovecotConf =
    ''
      base_dir = /var/run/dovecot2/

      protocols = imap pop3
    ''
    + (if cfg.sslServerCert!="" then
    ''
      ssl_cert = <${cfg.sslServerCert}
      ssl_key = <${cfg.sslServerKey}
      ssl_ca = <${cfg.sslCACert}
      disable_plaintext_auth = yes
    '' else ''
      ssl = no
      disable_plaintext_auth = no
    '')

    + ''
      default_internal_user = ${cfg.user}

      mail_location = ${cfg.mailLocation}

      maildir_copy_with_hardlinks = yes

      auth_mechanisms = plain login
      service auth {
        user = root
      }
      userdb {
        driver = passwd
      }
      passdb {
        driver = pam
        args = dovecot2
      }

      pop3_uidl_format = %08Xv%08Xu
    '';

  confFile = pkgs.writeText "dovecot.conf" dovecotConf;

in

{

  ###### interface

  options = {

    services.dovecot2 = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the Dovecot 2.x POP3/IMAP server.";
      };

      user = mkOption {
        default = "dovecot2";
        description = "Dovecot user name.";
      };

      group = mkOption {
        default = "dovecot2";
        description = "Dovecot group name.";
      };

      mailLocation = mkOption {
        default = "maildir:/var/spool/mail/%u"; /* Same as inbox, as postfix */
        example = "maildir:~/mail:INBOX=/var/spool/mail/%u";
        description = ''
          Location that dovecot will use for mail folders. Dovecot mail_location option.
        '';
      };

      sslServerCert = mkOption {
        default = "";
        description = "Server certificate";
      };

      sslCACert = mkOption {
        default = "";
        description = "CA certificate used by the server certificate.";
      };

      sslServerKey = mkOption {
        default = "";
        description = "Server key.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.dovecot2.enable {

    security.pam.services = [ { name = "dovecot2"; } ];

    users.extraUsers = [
      { name = cfg.user;
        uid = config.ids.uids.dovecot2;
        description = "Dovecot user";
        group = cfg.group;
      }
      { name = "dovenull";
        uid = config.ids.uids.dovenull2;
        description = "Dovecot user for untrusted logins";
        group = cfg.group;
      }
    ];

    users.extraGroups = singleton
      { name = cfg.group;
        gid = config.ids.gids.dovecot2;
      };

    jobs.dovecot2 =
      { description = "Dovecot IMAP/POP3 server";

        startOn = "started networking";

        preStart =
          ''
            ${pkgs.coreutils}/bin/mkdir -p /var/run/dovecot2 /var/run/dovecot2/login
            ${pkgs.coreutils}/bin/chown -R ${cfg.user}:${cfg.group} /var/run/dovecot2
          '';

        exec = "${pkgs.dovecot_2_0}/sbin/dovecot -F -c ${confFile}";
      };

    environment.systemPackages = [ pkgs.dovecot_2_0 ];

  };

}
