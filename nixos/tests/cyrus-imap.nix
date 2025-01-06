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

  testScript = ''
    machine.wait_for_unit("saslauthd.service")
    machine.wait_for_unit("cyrus-imap.service")

    machine.wait_for_open_port(80)
    machine.wait_for_open_port(143)

    machine.succeed("echo 'secret' | ${lib.getExe' pkgs.cyrus_sasl.bin "saslpasswd2"} -p -c cyrus")
    machine.succeed("chown cyrus /etc/sasldb2")

    machine.succeed("sudo -ucyrus curl --fail --max-time 10 imap://cyrus:secret@localhost:143")
    machine.fail("curl --fail --max-time 10 imap://cyrus:wrongsecret@localhost:143")
    machine.fail("curl --fail --max-time 10 -X PROPFIND -H 'Depth: 1' 'http://localhost/dav/addressbooks/user/cyrus@localhost/Default'")
  '';
}
