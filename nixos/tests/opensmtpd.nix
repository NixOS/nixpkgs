import ./make-test-python.nix {
  name = "opensmtpd";

  nodes = {
    smtp1 =
      { pkgs, ... }:
      {
        imports = [ common/user-account.nix ];
        networking = {
          firewall.allowedTCPPorts = [ 25 ];
          useDHCP = false;
          interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
            {
              address = "192.168.1.1";
              prefixLength = 24;
            }
          ];
        };
        environment.systemPackages =
          let
            testSendmail = pkgs.writeScriptBin "test-sendmail" ''
              #!/bin/sh
              set -euxo pipefail
              echo "========= SENDING" >&2
              ${pkgs.system-sendmail}/bin/sendmail -v -f alice@smtp1 bob@smtp2 >&2 <<EOF
              From: alice@smtp1
              To: bob@smtp2
              Subject: Sendmail Test

              Hello World
              EOF
              echo "=========== FINISHED SENDING" >&2
            '';
          in
          [
            pkgs.opensmtpd
            testSendmail
          ];
        services.opensmtpd = {
          enable = true;
          extraServerArgs = [ "-v" ];
          serverConfiguration = ''
            listen on 0.0.0.0
            action relay_smtp2 relay host "smtp://192.168.1.2"
            match from any for any action relay_smtp2
          '';
        };
      };

    smtp2 =
      { pkgs, ... }:
      {
        imports = [ common/user-account.nix ];
        networking = {
          firewall.allowedTCPPorts = [
            25
            143
          ];
          useDHCP = false;
          interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
          ];
        };
        environment.systemPackages = [ pkgs.opensmtpd ];
        services.opensmtpd = {
          enable = true;
          extraServerArgs = [ "-v" ];
          serverConfiguration = ''
            listen on 0.0.0.0
            action dovecot_deliver mda \
              "${pkgs.dovecot}/libexec/dovecot/deliver -d %{user.username}"
            match from any for local action dovecot_deliver
          '';
        };
        services.dovecot2 = {
          enable = true;
          enableImap = true;
          mailLocation = "maildir:~/mail";
          protocols = [ "imap" ];
        };
      };

    client =
      { pkgs, ... }:
      {
        networking = {
          useDHCP = false;
          interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
            {
              address = "192.168.1.3";
              prefixLength = 24;
            }
          ];
        };
        environment.systemPackages =
          let
            sendTestMail = pkgs.writeScriptBin "send-a-test-mail" ''
              #!${pkgs.python3.interpreter}
              import smtplib, sys

              with smtplib.SMTP('192.168.1.1') as smtp:
                smtp.sendmail('alice@smtp1', 'bob@smtp2', """
                  From: alice@smtp1
                  To: bob@smtp2
                  Subject: Test

                  Hello World
                """)
            '';

            checkMailLanded = pkgs.writeScriptBin "check-mail-landed" ''
              #!${pkgs.python3.interpreter}
              import imaplib

              with imaplib.IMAP4('192.168.1.2', 143) as imap:
                imap.login('bob', 'foobar')
                imap.select()
                status, refs = imap.search(None, 'ALL')
                assert status == 'OK'
                assert len(refs) == 1 and refs[0] != ""
                status, msg = imap.fetch(refs[0], '(BODY[TEXT])')
                assert status == 'OK'
                content = msg[0][1]
                print("===> content:", content)
                split = content.split(b'\r\n')
                print("===> split:", split)
                split.reverse()
                lastline = next(filter(lambda x: x != b"", map(bytes.strip, split)))
                print("===> lastline:", lastline)
                assert lastline.strip() == b'Hello World'
                imap.store(refs[0], '+FLAGS', '\\Deleted')
                imap.expunge()
            '';
          in
          [
            sendTestMail
            checkMailLanded
          ];
      };
  };

  testScript = ''
    start_all()

    client.systemctl("start network-online.target")
    client.wait_for_unit("network-online.target")
    smtp1.wait_for_unit("opensmtpd")
    smtp2.wait_for_unit("opensmtpd")
    smtp2.wait_for_unit("dovecot2")

    # To prevent sporadic failures during daemon startup, make sure
    # services are listening on their ports before sending requests
    smtp1.wait_for_open_port(25)
    smtp2.wait_for_open_port(25)
    smtp2.wait_for_open_port(143)

    client.succeed("send-a-test-mail")
    smtp1.wait_until_fails("smtpctl show queue | egrep .")
    smtp2.wait_until_fails("smtpctl show queue | egrep .")
    client.succeed("check-mail-landed >&2")

    smtp1.succeed("test-sendmail")
    smtp1.wait_until_fails("smtpctl show queue | egrep .")
    smtp2.wait_until_fails("smtpctl show queue | egrep .")
    client.succeed("check-mail-landed >&2")
  '';

  meta.timeout = 1800;
}
