{ lib, ... }:
let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  # imapgoose always connects over TLS and validates the certificate, so we use
  # the snakeoil cert's hostname consistently and trust its CA system-wide.
  domain = certs.domain;
  # matches the alice and bob accounts from common/user-account.nix
  password = "foobar";
in
{
  name = "imapgoose";
  meta.maintainers = with lib.maintainers; [ bobberb ];

  nodes.machine =
    { config, pkgs, ... }:
    let
      # Appends a message to a user's INBOX over IMAP+TLS. User, password,
      # Subject and Message-ID are taken from argv so the same client can inject
      # both the startup-sync probes and the later live-NOTIFY probe against the
      # running dovecot server, for either mailbox user.
      appendTestMail = pkgs.writers.writePython3Bin "append-testmail" { } ''
        import imaplib
        import sys

        user = sys.argv[1]
        subject = sys.argv[2]
        message_id = sys.argv[3]

        message = (
            b"From: root@localhost\r\n"
            b"To: " + user.encode() + b"@localhost\r\n"
            b"Subject: " + subject.encode() + b"\r\n"
            b"Message-ID: <" + message_id.encode() + b"@localhost>\r\n"
            b"\r\n"
            b"Hello from the IMAP server!\r\n"
        )

        imap = imaplib.IMAP4_SSL("${domain}", 993)
        imap.login(user, "${password}")
        status, data = imap.append("INBOX", None, None, message)
        assert status == "OK", (status, data)
        imap.logout()
      '';

      passwordCommand = [
        "${pkgs.writeShellScript "imapgoose-pw" "echo ${password}"}"
      ];
    in
    {
      imports = [ ./common/user-account.nix ];

      networking.hosts."127.0.0.1" = [ domain ];
      security.pki.certificateFiles = [ certs.ca.cert ];
      networking.firewall.allowedTCPPorts = [ 993 ];

      services.dovecot2 = {
        enable = true;
        enablePAM = true;
        settings = {
          dovecot_config_version = config.services.dovecot2.package.version;
          dovecot_storage_version = config.services.dovecot2.package.version;
          mail_driver = "maildir";
          # Keep the server-side mailstore out of ~/mail so it does not collide
          # with imapgoose's local Maildirs at ~/mail/personal.
          mail_path = "~/Mail";
          protocols.imap = true;
          ssl_server_ca_file = "${certs.ca.cert}";
          ssl_server_cert_file = "${certs.${domain}.cert}";
          ssl_server_key_file = "${certs.${domain}.key}";

          # Enable the IMAP NOTIFY extension imapgoose uses for real-time sync.
          mailbox_list_index = true;
          "protocol imap".mail_plugins.notify = true;
        };
      };

      # Two instances, one per OS user, each syncing that user's own mailbox
      # into that user's home. This proves per-user isolation: each daemon runs
      # as its own user and writes only its own Maildir.
      services.imapgoose.instances = {
        alice = {
          verbose = true;
          accounts.personal = {
            server = domain;
            username = "alice";
            inherit passwordCommand;
            localPath = "/home/alice/mail/personal";
          };
        };
        bob = {
          verbose = true;
          # Relocate bob's SQLite status databases out of the default
          # /var/lib/imapgoose/bob StateDirectory to a path under his home. This
          # exercises the stateDir option: the dir must be created by tmpfiles,
          # owned by bob, and writable under the hardened unit (ReadWritePaths).
          stateDir = "/home/bob/.imapgoose-state";
          accounts.personal = {
            server = domain;
            username = "bob";
            inherit passwordCommand;
            localPath = "/home/bob/mail/personal";
          };
        };
      };

      environment.systemPackages = [ appendTestMail ];
    };

  testScript = ''
    machine.wait_for_unit("dovecot.service")

    # Startup-sync path: inject a message into each user's INBOX BEFORE the
    # daemons start so they are picked up by imapgoose's full sync on connect.
    # APPEND over TLS as each user so dovecot stores and indexes with correct
    # ownership.
    machine.succeed("append-testmail alice AliceStartupProbe alice-startup-12345")
    machine.succeed("append-testmail bob BobStartupProbe bob-startup-12345")

    # Both instances are distinct systemd units; each performs a full sync on
    # startup so the seeded message should appear in the matching local Maildir.
    machine.wait_for_unit("imapgoose-alice.service")
    machine.wait_for_unit("imapgoose-bob.service")

    machine.wait_until_succeeds(
        "grep -rl 'alice-startup-12345@localhost' /home/alice/mail/personal/", timeout=120
    )
    machine.wait_until_succeeds(
        "grep -rl 'bob-startup-12345@localhost' /home/bob/mail/personal/", timeout=120
    )

    # Isolation: each instance ran as its own user, so the delivered file must be
    # owned by that user. This is the core guarantee of the per-user design.
    alice_file = machine.succeed(
        "grep -rl 'alice-startup-12345@localhost' /home/alice/mail/personal/"
    ).strip()
    bob_file = machine.succeed(
        "grep -rl 'bob-startup-12345@localhost' /home/bob/mail/personal/"
    ).strip()
    assert machine.succeed(f"stat -c %U {alice_file}").strip() == "alice", "alice's mail not owned by alice"
    assert machine.succeed(f"stat -c %U {bob_file}").strip() == "bob", "bob's mail not owned by bob"

    # Per-instance state isolation and the stateDir override. alice keeps the
    # default: her SQLite db lands under her StateDirectory
    # (XDG_STATE_HOME=/var/lib/imapgoose/alice, plus imapgoose's own "imapgoose/"
    # component), owned by alice. bob relocated his via stateDir, so his db must
    # instead land under /home/bob/.imapgoose-state/imapgoose/, owned by bob, and
    # nothing must appear under the default /var/lib/imapgoose/bob path.
    machine.wait_until_succeeds("ls /var/lib/imapgoose/alice/imapgoose/*.db")
    machine.wait_until_succeeds("ls /home/bob/.imapgoose-state/imapgoose/*.db")
    assert machine.succeed(
        "stat -c %U /var/lib/imapgoose/alice/imapgoose/*.db"
    ).strip() == "alice"
    assert machine.succeed(
        "stat -c %U /home/bob/.imapgoose-state/imapgoose/*.db"
    ).strip() == "bob"
    # bob's custom stateDir itself must be owned by bob (created by tmpfiles).
    assert machine.succeed(
        "stat -c %U /home/bob/.imapgoose-state"
    ).strip() == "bob"
    # And the default StateDirectory for bob must not hold his databases.
    machine.fail("ls /var/lib/imapgoose/bob/imapgoose/*.db")

    # Live-push path: with alice's daemon already running and the initial sync
    # done, APPEND a second, distinct message to alice's INBOX. It is not covered
    # by the startup full sync, so its arrival in the local Maildir proves the
    # live, IMAP-NOTIFY-driven pull while the daemon is up.
    machine.succeed("append-testmail alice AliceLiveProbe alice-live-67890")
    machine.wait_until_succeeds(
        "grep -rl 'alice-live-67890@localhost' /home/alice/mail/personal/", timeout=120
    )

    machine.log(
        machine.succeed("systemd-analyze security imapgoose-alice.service | grep -v ✓ || true")
    )
  '';
}
