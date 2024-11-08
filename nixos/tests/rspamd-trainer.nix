import ./make-test-python.nix ({ pkgs, ... }:
let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in {
  name = "rspamd-trainer";
  meta = with pkgs.lib.maintainers; { maintainers = [ onny ]; };

  nodes = {
    machine = { options, config, ... }: {

      security.pki.certificateFiles = [
        certs.ca.cert
      ];

      networking.extraHosts = ''
        127.0.0.1 ${domain}
     '';

      services.rspamd-trainer = {
        enable = true;
        settings = {
          HOST = domain;
          USERNAME = "spam@${domain}";
          INBOXPREFIX = "INBOX/";
        };
        secrets = [
          # Do not use this in production. This will make passwords
          # world-readable in the Nix store
          "${pkgs.writeText "secrets" ''
            PASSWORD = test123
          ''}"
        ];
      };

      services.maddy = {
        enable = true;
        hostname = domain;
        primaryDomain = domain;
        ensureAccounts = [ "spam@${domain}" ];
        ensureCredentials = {
          # Do not use this in production. This will make passwords world-readable
          # in the Nix store
          "spam@${domain}".passwordFile = "${pkgs.writeText "postmaster" "test123"}";
        };
        tls = {
          loader = "file";
          certificates = [{
            certPath = "${certs.${domain}.cert}";
            keyPath = "${certs.${domain}.key}";
          }];
        };
        config = builtins.replaceStrings [
          "imap tcp://0.0.0.0:143"
          "submission tcp://0.0.0.0:587"
        ] [
          "imap tls://0.0.0.0:993 tcp://0.0.0.0:143"
          "submission tls://0.0.0.0:465 tcp://0.0.0.0:587"
        ] options.services.maddy.config.default;
      };

      services.rspamd = {
        enable = true;
        locals = {
          "redis.conf".text = ''
            servers = "${config.services.redis.servers.rspamd.unixSocket}";
          '';
          "classifier-bayes.conf".text = ''
            backend = "redis";
            autolearn = true;
          '';
        };
      };

      services.redis.servers.rspamd = {
        enable = true;
        port = 0;
        unixSocket = "/run/redis-rspamd/redis.sock";
        user = config.services.rspamd.user;
      };

      environment.systemPackages = [
        (pkgs.writers.writePython3Bin "send-testmail" { } ''
          import smtplib
          import ssl
          from email.mime.text import MIMEText
          context = ssl.create_default_context()
          msg = MIMEText("Hello World")
          msg['Subject'] = 'Test'
          msg['From'] = "spam@${domain}"
          msg['To'] = "spam@${domain}"
          with smtplib.SMTP_SSL(host='${domain}', port=465, context=context) as smtp:
              smtp.login('spam@${domain}', 'test123')
              smtp.sendmail(
                'spam@${domain}', 'spam@${domain}', msg.as_string()
              )
        '')
        (pkgs.writers.writePython3Bin "create-mail-dirs" { } ''
          import imaplib
          with imaplib.IMAP4_SSL('${domain}') as imap:
              imap.login('spam@${domain}', 'test123')
              imap.create("\"INBOX/report_spam\"")
              imap.create("\"INBOX/report_ham\"")
              imap.create("\"INBOX/report_spam_reply\"")
              imap.select("INBOX")
              imap.copy("1", "\"INBOX/report_ham\"")
              imap.logout()
        '')
        (pkgs.writers.writePython3Bin "test-imap" { } ''
          import imaplib
          with imaplib.IMAP4_SSL('${domain}') as imap:
              imap.login('spam@${domain}', 'test123')
              imap.select("INBOX/learned_ham")
              status, refs = imap.search(None, 'ALL')
              assert status == 'OK'
              assert len(refs) == 1
              status, msg = imap.fetch(refs[0], 'BODY[TEXT]')
              assert status == 'OK'
              assert msg[0][1].strip() == b"Hello World"
              imap.logout()
        '')
      ];



    };

  };

  testScript = { nodes }: ''
    start_all()
    machine.wait_for_unit("maddy.service")
    machine.wait_for_open_port(143)
    machine.wait_for_open_port(993)
    machine.wait_for_open_port(587)
    machine.wait_for_open_port(465)

    # Send test mail to spam@domain
    machine.succeed("send-testmail")

    # Create mail directories required for rspamd-trainer and copy mail from
    # INBOX into INBOX/report_ham
    machine.succeed("create-mail-dirs")

    # Start rspamd-trainer. It should read mail from INBOX/report_ham
    machine.wait_for_unit("rspamd.service")
    machine.wait_for_unit("redis-rspamd.service")
    machine.wait_for_file("/run/rspamd/rspamd.sock")
    machine.succeed("systemctl start rspamd-trainer.service")

    # Check if mail got processed by rspamd-trainer successfully and check for
    # it in INBOX/learned_ham
    machine.succeed("test-imap")
  '';
})
