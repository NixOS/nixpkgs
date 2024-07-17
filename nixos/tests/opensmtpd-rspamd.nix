import ./make-test-python.nix {
  name = "opensmtpd-rspamd";

  nodes = {
    smtp1 =
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
              address = "192.168.1.1";
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

            action do_relay relay
            # DO NOT DO THIS IN PRODUCTION!
            # Setting up authentication requires a certificate which is painful in
            # a test environment, but THIS WOULD BE DANGEROUS OUTSIDE OF A
            # WELL-CONTROLLED ENVIRONMENT!
            match from any for any action do_relay
          '';
        };
        services.dovecot2 = {
          enable = true;
          enableImap = true;
          mailLocation = "maildir:~/mail";
          protocols = [ "imap" ];
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
        services.rspamd = {
          enable = true;
          locals."worker-normal.inc".text = ''
            bind_socket = "127.0.0.1:11333";
          '';
        };
        services.opensmtpd = {
          enable = true;
          extraServerArgs = [ "-v" ];
          serverConfiguration = ''
            filter rspamd proc-exec "${pkgs.opensmtpd-filter-rspamd}/bin/filter-rspamd"
            listen on 0.0.0.0 filter rspamd
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
                smtp.sendmail('alice@[192.168.1.1]', 'bob@[192.168.1.2]', """
                  From: alice@smtp1
                  To: bob@smtp2
                  Subject: Test

                  Hello World
                  Here goes the spam test
                  XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-STANDARD-ANTI-UBE-TEST-EMAIL*C.34X
                """)
            '';

            checkMailBounced = pkgs.writeScriptBin "check-mail-bounced" ''
              #!${pkgs.python3.interpreter}
              import imaplib

              with imaplib.IMAP4('192.168.1.1', 143) as imap:
                imap.login('alice', 'foobar')
                imap.select()
                status, refs = imap.search(None, 'ALL')
                assert status == 'OK'
                assert len(refs) == 1
                status, msg = imap.fetch(refs[0], 'BODY[TEXT]')
                assert status == 'OK'
                content = msg[0][1]
                print("===> content:", content)
                assert b"An error has occurred while attempting to deliver a message" in content
            '';
          in
          [
            sendTestMail
            checkMailBounced
          ];
      };
  };

  testScript = ''
    start_all()

    client.systemctl("start network-online.target")
    client.wait_for_unit("network-online.target")
    smtp1.wait_for_unit("opensmtpd")
    smtp2.wait_for_unit("opensmtpd")
    smtp2.wait_for_unit("rspamd")
    smtp2.wait_for_unit("dovecot2")

    # To prevent sporadic failures during daemon startup, make sure
    # services are listening on their ports before sending requests
    smtp1.wait_for_open_port(25)
    smtp2.wait_for_open_port(25)
    smtp2.wait_for_open_port(143)
    smtp2.wait_for_open_port(11333)

    client.succeed("send-a-test-mail")
    smtp1.wait_until_fails("smtpctl show queue | egrep .")
    client.succeed("check-mail-bounced >&2")
  '';

  meta.timeout = 1800;
}
