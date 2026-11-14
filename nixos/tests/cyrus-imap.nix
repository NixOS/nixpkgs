{ lib, ... }:
{
  name = "cyrus-imap";

  meta = {
    maintainers = with lib.maintainers; [ moraxyc ];
  };

  nodes = {
    server =
      { pkgs, ... }:
      {
        imports = [ ./common/user-account.nix ];
        environment.systemPackages =
          let
            sendTestMail = pkgs.writeScriptBin "send-testmail" ''
              #!${pkgs.runtimeShell}
              exec sendmail -vt <<MAIL
              From: alice@localhost
              To: bob@localhost
              Subject: Very important!

              Hello world!
              MAIL
            '';

            prepareMailBoxes =
              pkgs.writers.writePython3Bin "prepare-mailbox"
                {
                  libraries = [ pkgs.python3Packages.pexpect ];
                }
                ''
                  import pexpect

                  child = pexpect.spawn('cyradm --user cyrus 127.0.0.1')

                  child.expect('Password:')
                  child.sendline('secret')

                  child.expect('127.0.0.1>')
                  child.sendline('cm user/alice')

                  child.expect('127.0.0.1>')
                  child.sendline('cm user/bob')

                  child.expect('127.0.0.1>')
                  child.sendline('quit')

                  child.expect(pexpect.EOF)
                '';
          in
          with pkgs;
          [
            curl
            sudo
            cyrus_sasl.bin
            sendTestMail
            prepareMailBoxes
          ];
        services.postfix = {
          enable = true;
          config = {
            mailbox_transport = "lmtp:unix:/run/cyrus/lmtp";
          };
        };
        services.saslauthd = {
          enable = true;
          config = ''
            DESC="SASL Authentication Daemon"
            NAME="saslauthd"
            MECH_OPTIONS=""
            THREADS=5
            START=yes
            OPTIONS="-c -m /run/saslauthd"
          '';
        };
        services.cyrus-imap = {
          enable = true;
          imapdSettings = {
            admins = [ "cyrus" ];
            allowplaintext = true;
            defaultdomain = "localhost";
            defaultpartition = "default";
            partition-default = "/var/lib/cyrus/storage";
            duplicate_db_path = "/run/cyrus/db/deliver.db";
            hashimapspool = true;
            httpmodules = [
              "carddav"
              "caldav"
            ];
            mboxname_lockpath = "/run/cyrus/lock";
            popminpoll = 1;
            proc_path = "/run/cyrus/proc";
            ptscache_db_path = "/run/cyrus/db/ptscache.db";
            sasl_auto_transition = true;
            sasl_pwcheck_method = [ "saslauthd" ];
            sievedir = "/var/lib/cyrus/sieve";
            statuscache_db_path = "/run/cyrus/db/statuscache.db";
            syslog_prefix = "cyrus";
            tls_client_ca_dir = "/etc/ssl/certs";
            tls_session_timeout = 1440;
            tls_sessions_db_path = "/run/cyrus/db/tls_sessions.db";
            virtdomains = "off";
          };
          cyrusSettings = {
            START = {
              recover = {
                cmd = [
                  "ctl_cyrusdb"
                  "-r"
                ];
              };
            };
            EVENTS = {
              tlsprune = {
                cmd = [ "tls_prune" ];
                at = 400;
              };
              delprune = {
                cmd = [
                  "cyr_expire"
                  "-E"
                  "3"
                ];
                at = 400;
              };
              deleteprune = {
                cmd = [
                  "cyr_expire"
                  "-E"
                  "4"
                  "-D"
                  "28"
                ];
                at = 430;
              };
              expungeprune = {
                cmd = [
                  "cyr_expire"
                  "-E"
                  "4"
                  "-X"
                  "28"
                ];
                at = 445;
              };
              checkpoint = {
                cmd = [
                  "ctl_cyrusdb"
                  "-c"
                ];
                period = 30;
              };
            };
            SERVICES = {
              http = {
                cmd = [ "httpd" ];
                listen = "80";
                prefork = 0;
              };
              imap = {
                cmd = [ "imapd" ];
                listen = "143";
                prefork = 0;
              };
              lmtpunix = {
                cmd = [ "lmtpd" ];
                listen = "/run/cyrus/lmtp";
                prefork = 0;
              };
              notify = {
                cmd = [ "notifyd" ];
                listen = "/run/cyrus/notify";
                proto = "udp";
                prefork = 0;
              };
            };
          };
        };
      };
  };

  testScript = ''
    with subtest("Check basic services and open ports"):
        server.wait_for_unit("saslauthd.service")
        server.wait_for_unit("cyrus-imap.service")
        server.wait_for_open_port(80)
        server.wait_for_open_port(143)

    with subtest("Set SASL passwords"):
        server.succeed("echo 'secret' | saslpasswd2 -p -c cyrus")
        server.succeed("echo 'secret' | saslpasswd2 -p -c alice")
        server.succeed("echo 'secret' | saslpasswd2 -p -c bob")
        server.succeed("chown cyrus /etc/sasldb2")

    with subtest("Test login"):
        server.succeed("curl --verbose --fail --max-time 10 imap://cyrus:secret@localhost:143")
        server.fail("curl --verbose --fail --max-time 10 imap://cyrus:wrongsecret@localhost:143")

    with subtest("Send and receive mail"):
        server.succeed("prepare-mailbox")
        server.succeed("sudo -ualice send-testmail")
        assert "Hello world!" in server.wait_until_succeeds("curl --user bob:secret --url 'imap://localhost/INBOX;UID=1'")
  '';
}
