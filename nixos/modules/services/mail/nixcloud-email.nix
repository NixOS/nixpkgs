{ config, pkgs, lib, options, ... } @ toplevel:
with lib;

let
  cfg = config.nixcloud.email;
in
{
  imports = [ ./virtual-mail-users.nix ];
  options = {
    nixcloud.email = mkOption {
      default = {};
      description = ''
        nixcloud.email simplifies mailserver hosting by providing a minimal abstraction with useful defaults.
      '';
      type = types.submodule ({ config, ... } : {
        config._module.args.toplevel = toplevel;
        options = {
          enable = mkOption {
            default = false;
            description = ''
              nixcloud.io email abstraction, optimized for simple usage yet supporting complex features.
            '';
          };
          ipAddress = mkOption {
            example = "1.2.3.4";
            description = ''
              The IPv4 address used for the email service.
            '';
          };
          ip6Address = mkOption {
            example = "2001:0db8:85a3:0000:0000:8a2e:0370:7334";
            description = ''
              The IPv6 address used for the email service. Note: You need to set the reverse PTR correctly or you can't send emails to gmail.com for instance.
            '';
          };
          domains = mkOption {
            type = types.listOf (types.str);
            example = [ "example.com" ];
            description = ''
              The domains for which the mailserver is responsible.
            '';
          };
          hostname = mkOption {
            type = types.str;
            example = "mail.example.com";
            default = toplevel.config.networking.hostName;
            description = ''
              The domain the MX record points to and hostname needs not be listed in domains. Used by Postfix and ACME.
            '';
          };
          enableSpamassassin = mkOption {
            type = types.bool;
            default = true;
            description = ''
              SpamAssassin is the #1 Open Source anti-spam platform giving system administrators a filter to classify email and block spam (unsolicited bulk email).
            '';
          };
          enableGreylisting = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Enable the Postfix policy server implementing greylisting developed by David Schweikert.
            '';
          };
          enableMailQuota = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Dovecot2 mail quotas - https://wiki2.dovecot.org/Quota
            '';
          };
          enableDKIM = mkOption {
            type = types.bool;
            default = true;
            description = ''
              A community effort to develop and maintain a C library for producing DKIM-aware applications and an open source milter for providing DKIM servicei (http://opendkim.org/). 
            '';
          };
          enableACME= mkOption {
            type = types.bool;
            default = true;
            description = ''
              Let’s Encrypt uses the ACME protocol to verify that you control a given domain name and to issue you a certificate.
            '';
          };
          users = mkOption {
            type = types.listOf (types.submodule (import ./virtual-mail-submodule.nix));
            example = [ { name = "js"; domain = "nixcloud.io"; password="qwertz"; } ];
            default = [];
            description = "A list of virtual mail users for which the password is managed via this abstraction";
          };
        };
      });
    };
  };

  config = mkIf (config.nixcloud.email.enable == true)
    (mkMerge [ 

      ({ 
        networking = {
          firewall = {
            allowPing = true;
            allowedTCPPorts = [
              25               # master (postfix)
              143              # imap (dovecot)
              587              # dovecot (submission)
              993              # imaps (dovecot)
              4190             # sieve
            ];
          };
        };
      })


      ({
        services.mailUsers.users = cfg.users; 
      })
      
      (mkIf cfg.enableSpamassassin {
        services.spamassassin = {
          enable = true;
          #debug = true;
          config = ''
            #rewrite_header Subject [***** SPAM _SCORE_ *****]
            required_score          5.0
            use_bayes               1
            bayes_auto_learn        1
            add_header all Status _YESNO_, score=_SCORE_ required=_REQD_ tests=_TESTS_ autolearn=_AUTOLEARN_ version=_VERSION_
          '';
        };
      })

      (mkIf cfg.enableACME { 
        networking = {
          firewall = {
            allowedTCPPorts = [
              80
            ];
          };
        };

        services.nginx = {
          enable = true;
          virtualHosts.mail= {
            default = true;
            enableACME = true;
            #serverName = "mail.nix.lt";
            serverName = cfg.hostname;
            # FIXME eventually we want to run these commands after a cert update
            #acmePostRun =
            #  systemctl restart httpd.service;
            #  systemctl restart postfix.service;
            #  systemctl restart dovecot2.service;
            #'';
          };
        };
      })

      (mkIf cfg.enableDKIM {
        users.users.postfix.extraGroups = [ "opendkim" ];
        services.opendkim = {
          enable = true;
          selector = "mail";
          keyPath = "/var/lib/dkim/keys/";
          #domains = "csl:nix.lt";
          domains = "csl:${lib.concatStringsSep "," cfg.domains}";
          configFile = pkgs.writeText "opendkim.conf" ''
            UMask 0002
          '';
        };
      })

      (mkIf cfg.enableGreylisting {
        services.postgrey = {
          enable = true;
        };
      })

      # for sending emails (optional)
      { 
        services.postfix = {
          enable = true;
          enableHeaderChecks = true;
          masterConfig = {
            smtp_inet = {
              args = [ "-o" "content_filter=spamassassin" "-o" "smtp_bind_address=${cfg.ipAddress}" "-o" "smtp_bind_address6=${cfg.ip6Address}"];
            };
            spamassassin = {
              command = "pipe";
              args = [ "user=spamd" "argv=${pkgs.spamassassin}/bin/spamc" "-f" "-e" "/run/wrappers/bin/sendmail" "-oi" "-f" ''''${sender}'' ''''${recipient}'' ];
              privileged = true;
            };
          };
          setSendmail = true;
          hostname = cfg.hostname;
          destination = [
            "localhost"
          ];
          enableSubmission=true;
          submissionOptions = {
            "smtpd_tls_security_level" = "encrypt";
            "smtpd_sasl_auth_enable" = "yes";
            "smtpd_client_restrictions" = "permit_sasl_authenticated,reject";
            "smtpd_sasl_type" = "dovecot";
            "smtpd_sasl_path" = "private/auth";
          };

          config = {
            smtpd_tls_auth_only = true;
            message_size_limit = "100480000";
            mailbox_size_limit = "1004800000";
            virtual_mailbox_domains = cfg.domains;
            virtual_transport = "lmtp:unix:private/lmtp-dovecot";

            smtpd_sasl_auth_enable = true;
            smtpd_sasl_security_options = "noanonymous";
            broken_sasl_auth_clients = true;
 
            smtpd_relay_restrictions = [
              "reject_non_fqdn_recipient"
              "reject_unknown_recipient_domain"
              "permit_mynetworks"
              "permit_sasl_authenticated"
              "reject_unauth_destination"
            ];
            smtpd_client_restrictions = [
              "permit_mynetworks"
              "permit_sasl_authenticated"
              "reject_unknown_client_hostname" # reject reverse PTR not matching hostname
            ];
            smtpd_helo_required = "yes";
            smtpd_helo_restrictions = [
              "permit_mynetworks"
              # with this three lines i can't send emails from mac os x computers and ipads...
              # Fehler beim Senden der Nachricht: Der Mail-Server antwortete:
              # 4.7.1 <RoswithsMini572.fritz.box>: Helo command rejected: Host not found.
              #  Bitte überprüfen Sie die E-Mail-Adresse des Empfängers "rs@dune2.de" und wiederholen Sie den Vorgang.
              #"reject_invalid_helo_hostname"
              #"reject_non_fqdn_helo_hostname"
              #"reject_unknown_helo_hostname"
            ];

            # Add some security
            smtpd_recipient_restrictions = [
              "reject_unknown_sender_domain"    # prevents spam
              "reject_unknown_recipient_domain" # prevents spam
              "reject_unauth_pipelining"        # prevent bulk mail spam
              "permit_sasl_authenticated"
              "permit_mynetworks"
              "reject_unauth_destination"
              "check_policy_service inet:localhost:12340" # quota
              "check_policy_service unix:/var/run/postgrey.sock" # postgrey
            ] ++ (if cfg.enableGreylisting then [ "check_policy_service unix:/var/run/postgrey.sock" ] else []); # postgrey
            smtpd_milters = [ "unix:/run/opendkim/opendkim.sock" ]; # [ "inet:localhost:12301" ];
            non_smtpd_milters = [ "unix:/run/opendkim/opendkim.sock" ]; # [ "inet:localhost:12301" ];
            smtpd_tls_received_header = true;
          };
        } // optionalAttrs (cfg.enableACME) {
          sslCert = "/var/lib/acme/${cfg.hostname}/fullchain.pem";
          sslKey = "/var/lib/acme/${cfg.hostname}/key.pem";
        };

        services.dovecot2 = {
          enable = true;
          enableImap = true;
          enableLmtp = true;
          enablePAM = false;
          enableQuota = true;
          mailLocation = "maildir:/var/lib/virtualMail/%d/users/%n/mail";

          mailUser = "virtualMail";
          mailGroup = "virtualMail";


          # refactor this into services.dovecot2 mkOption -> mailuser & mailgroup
          # sieve shall be a mkOption in dovecot2
          modules = [ pkgs.dovecot_pigeonhole ];

          protocols = [ "sieve" ];

          sieveScripts = {
            before = pkgs.writeText "before.sieve" ''
              require ["fileinto", "reject", "envelope", "mailbox", "reject"];
              
              if header :contains "X-Spam-Flag" "YES" {
                fileinto :create "Spam";
                stop;
              }
            '';
          };

          mailboxes = [
            { name = "Trash";
              auto = "create";
              specialUse = "Trash";
            }

            { name = "Drafts";
              auto = "create";
              specialUse = "Drafts";
            }

            { name = "Sent";
              auto = "create";
              specialUse = "Sent";
            }

            { name = "Spam";
              auto = "create";
              specialUse = "Junk";
            }
          ];

          extraConfig = ''
            mail_home = /var/lib/virtualMail/%d/users/%n/

            passdb {
              driver = passwd-file
              args = username_format=%n ${config.services.mailUsers.virtualMailEnv}/%d
            }

            userdb {
              driver = static
              args = uid=${config.services.dovecot2.mailUser} gid=${config.services.dovecot2.mailGroup}
            }

            service auth {
              unix_listener /var/lib/postfix/queue/private/auth {
                mode = 0660
                user = postfix
                group = postfix        
              }
            }

            service lmtp {
              unix_listener /var/lib/postfix/queue/private/lmtp-dovecot {
                mode = 0660
                user = postfix
                group = postfix
              }
            }

            protocol lmtp {
              mail_plugins = $mail_plugins sieve
            }

            plugin sieve {
              sieve = /var/lib/virtualMail/%d/users/%n/sieve.active
              sieve_dir = /var/lib/virtualMail/%d/users/%n/sieve
            }
          '';
        } // optionalAttrs (cfg.enableACME) { 
            sslServerCert = "/var/lib/acme/${cfg.hostname}/fullchain.pem";
            sslServerKey = "/var/lib/acme/${cfg.hostname}/key.pem";
        }; 
      }
    ]);
}
