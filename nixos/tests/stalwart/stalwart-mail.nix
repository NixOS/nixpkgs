# Rudimentary test checking that the Stalwart email server can:
# - receive some message through SMTP submission, then
# - serve this message through IMAP.

let
  certs = import ../common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
{ lib, ... }:
{
  name = "stalwart-mail";

  nodes.main =
    { pkgs, ... }:
    {
      imports = [
        ./stalwart-mail-config.nix
      ];

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
      main.wait_for_open_port(80)

      main.succeed("test-smtp-submission")

      # restart stalwart to test rocksdb compaction of existing database
      main.succeed("systemctl restart stalwart-mail.service")
      main.wait_for_open_port(587)
      main.wait_for_open_port(143)
      main.wait_for_open_port(80)

      main.succeed("test-imap-read")

      main.succeed("test -d /var/cache/stalwart-mail/STALWART_WEBADMIN")
      main.succeed("curl --fail http://localhost")
    '';

  meta = {
    maintainers = with lib.maintainers; [
      happysalada
      euxane
      onny
    ];
  };
}
