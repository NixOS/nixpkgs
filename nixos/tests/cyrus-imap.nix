{ lib, pkgs, ... }:
{
  name = "cyrus-imap";

  meta = {
    maintainers = with lib.maintainers; [ moraxyc ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        curl
        sudo
      ];
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
        cyrusSettings = {
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

  testScript = ''
    machine.wait_for_unit("saslauthd.service")
    machine.wait_for_unit("cyrus-imap.service")

    machine.wait_for_open_port(80)
    machine.wait_for_open_port(143)

    machine.succeed("echo 'secret' | ${pkgs.cyrus_sasl.bin}/bin/saslpasswd2 -p -c cyrus")
    machine.succeed("chown cyrus /etc/sasldb2")

    machine.succeed("sudo -ucyrus curl --fail --max-time 10 imap://cyrus:secret@localhost:143")
    machine.fail("curl --fail --max-time 10 imap://cyrus:wrongsecret@localhost:143")
    machine.fail("curl --fail --max-time 10 -X PROPFIND -H 'Depth: 1' 'http://localhost/dav/addressbooks/user/cyrus@localhost/Default'")
  '';
}
