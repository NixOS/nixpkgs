# Rudimentary test checking that the Stalwart email server can:
# - receive some message through SMTP submission, then
# - serve this message through IMAP.

let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;

in
import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "stalwart-mail";

    nodes.main =
      { pkgs, ... }:
      {
        security.pki.certificateFiles = [ certs.ca.cert ];

        services.stalwart-mail = {
          enable = true;
          settings = {
            server.hostname = domain;

            certificate."snakeoil" = {
              cert = "%{file:${certs.${domain}.cert}}%";
              private-key = "%{file:${certs.${domain}.key}}%";
            };

            server.tls = {
              certificate = "snakeoil";
              enable = true;
              implicit = false;
            };

            server.listener = {
              "smtp-submission" = {
                bind = [ "[::]:587" ];
                protocol = "smtp";
              };

              "imap" = {
                bind = [ "[::]:143" ];
                protocol = "imap";
              };
            };

            session.auth.mechanisms = "[plain]";
            session.auth.directory = "'in-memory'";
            storage.directory = "in-memory";

            session.rcpt.directory = "'in-memory'";
            queue.outbound.next-hop = "'local'";

            directory."in-memory" = {
              type = "memory";
              principals = [
                {
                  class = "individual";
                  name = "alice";
                  secret = "foobar";
                  email = [ "alice@${domain}" ];
                }
                {
                  class = "individual";
                  name = "bob";
                  secret = "foobar";
                  email = [ "bob@${domain}" ];
                }
              ];
            };
          };
        };

        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "test-smtp-submission" { } ''
            from smtplib import SMTP

            with SMTP('localhost', 587) as smtp:
                smtp.starttls()
                smtp.login('alice', 'foobar')
                smtp.sendmail(
                    'alice@${domain}',
                    'bob@${domain}',
                    """
                        From: alice@${domain}
                        To: bob@${domain}
                        Subject: Some test message

                        This is a test message.
                    """.strip()
                )
          '')

          (pkgs.writers.writePython3Bin "test-imap-read" { } ''
            from imaplib import IMAP4

            with IMAP4('localhost') as imap:
                imap.starttls()
                status, [caps] = imap.login('bob', 'foobar')
                assert status == 'OK'
                imap.select()
                status, [ref] = imap.search(None, 'ALL')
                assert status == 'OK'
                [msgId] = ref.split()
                status, msg = imap.fetch(msgId, 'BODY[TEXT]')
                assert status == 'OK'
                assert msg[0][1].strip() == b'This is a test message.'
          '')
        ];
      };

    testScript = # python
      ''
        main.wait_for_unit("stalwart-mail.service")
        main.wait_for_open_port(587)
        main.wait_for_open_port(143)

        main.succeed("test-smtp-submission")
        main.succeed("test-imap-read")
      '';

    meta = {
      maintainers = with lib.maintainers; [
        happysalada
        pacien
        onny
      ];
    };
  }
)
