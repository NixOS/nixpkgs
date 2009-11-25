{ config, pkgs, ... }:

with pkgs.lib;

let

  startingDependency = if config.services.gw6c.enable then "gw6c" else "network-interfaces";

  cfg = config.services.dovecot;

  dovecotConf = 
    ''
      base_dir = /var/run/dovecot/ 

      protocols = imap imaps pop3 pop3s
    ''
    + (if cfg.sslServerCert!="" then
    ''
      ssl_cert_file = ${cfg.sslServerCert}
      ssl_key_file = ${cfg.sslServerKey}
      ssl_ca_file = ${cfg.sslCACert}
    '' else ''
      ssl_disable = yes
      disable_plaintext_auth = no
    '')

    + ''
      login_user = ${cfg.user}
      login_chroot = no

      mail_location = maildir:/var/spool/mail/%u

      maildir_copy_with_hardlinks = yes

      auth default {
        mechanisms = plain login 
        userdb passwd {
        }
        passdb pam {
        }
        user = root 
      }
      auth_debug = yes
      auth_verbose = yes

      pop3_uidl_format = %08Xv%08Xu

      log_path = /var/log/dovecot.log
    '';
  
  confFile = pkgs.writeText "dovecot.conf" dovecotConf;

in

{

  ###### interface

  options = {
  
    services.dovecot = {
    
      enable = mkOption {
        default = false;
        description = "Whether to enable the Dovecot POP3/IMAP server.";
      };

      user = mkOption {
        default = "dovecot";
        description = "Dovecot user name.";
      };
      
      group = mkOption {
        default = "dovecot";
        description = "Dovecot group name.";
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

  config = mkIf config.services.dovecot.enable {

    security.pam.services = [ { name = "dovecot"; } ];

    users.extraUsers = singleton
      { name = cfg.user;
        uid = config.ids.uids.dovecot;
        description = "Dovecot user";
        group = cfg.group;
      };

    users.extraGroups = singleton
      { name = cfg.group;
        gid = config.ids.gids.dovecot;
      };

    jobs.dovecot =
      { description = "Dovecot IMAP/POP3 server";

        startOn = "started ${startingDependency}";

        preStart =
          ''
            ${pkgs.coreutils}/bin/mkdir -p /var/run/dovecot /var/run/dovecot/login 
            ${pkgs.coreutils}/bin/chown -R ${cfg.user}.${cfg.group} /var/run/dovecot
          '';

        exec = "${pkgs.dovecot}/sbin/dovecot -F -c ${confFile}";
      };
      
  };
  
}
