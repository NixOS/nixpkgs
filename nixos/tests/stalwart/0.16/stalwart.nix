# Rudimentary test checking that the Stalwart server can:
# - receive some message through SMTP submission, then
# - serve this message through IMAP.

let
  certs = import ../../common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
{ lib, ... }:
{
  name = "stalwart-0.16";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [
        ./stalwart-config.nix
      ];

      environment.systemPackages = [
        (pkgs.writers.writePython3Bin "test-smtp-submission" { } ''
          from smtplib import SMTP_SSL

          with SMTP_SSL("localhost", 465) as smtp:
              smtp.set_debuglevel(1)
              smtp.login("alice", "Aslkjfvnskdjfbn1!")
              smtp.sendmail(
                  "alice@${domain}",
                  "bob@${domain}",
                  """
                      From: alice@${domain}
                      To: bob@${domain}
                      Subject: Some test message

                      This is a test message.
                  """.strip()
              )
        '')

        (pkgs.writers.writePython3Bin "test-imap-read" { } ''
          from imaplib import IMAP4_SSL

          with IMAP4_SSL('localhost') as imap:
              status, [caps] = imap.login('bob', 'Ogisdhlbjknsgfbn1!')
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

  interactive.sshBackdoor.enable = true;

  testScript = # python
    ''
      def wait_for_ports():
        machine.wait_for_open_port(8080)
        machine.wait_for_open_port(25)
        machine.wait_for_open_port(465)
        machine.wait_for_open_port(993)
        machine.wait_for_open_port(995)
        machine.wait_for_open_port(4190)

      machine.wait_for_unit("stalwart.service")
      machine.succeed("systemctl start stalwart-provision.service")
      wait_for_ports()

      machine.succeed("test-smtp-submission")

      # restart stalwart to test rocksdb compaction of existing database
      machine.succeed("systemctl restart stalwart.service")
      wait_for_ports()

      machine.succeed("test-imap-read")

      machine.succeed("curl --fail http://localhost:8080")
    '';

  meta = {
    maintainers = with lib.maintainers; [
      hexstella
    ];
  };
}
