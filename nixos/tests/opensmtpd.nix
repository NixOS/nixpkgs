import ./make-test.nix {
  name = "opensmtpd";

  nodes = {
    smtp1 = { pkgs, ... }: {
      imports = [ common/user-account.nix ];
      networking = {
        firewall.allowedTCPPorts = [ 25 ];
        useDHCP = false;
        interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = "192.168.1.1"; prefixLength = 24; }
        ];
      };
      environment.systemPackages = [ pkgs.opensmtpd ];
      services.opensmtpd = {
        enable = true;
        extraServerArgs = [ "-v" ];
        serverConfiguration = ''
          listen on 0.0.0.0
          # DO NOT DO THIS IN PRODUCTION!
          # Setting up authentication requires a certificate which is painful in
          # a test environment, but THIS WOULD BE DANGEROUS OUTSIDE OF A
          # WELL-CONTROLLED ENVIRONMENT!
          accept from any for any relay
        '';
      };
    };

    smtp2 = { pkgs, ... }: {
      imports = [ common/user-account.nix ];
      networking = {
        firewall.allowedTCPPorts = [ 25 143 ];
        useDHCP = false;
        interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = "192.168.1.2"; prefixLength = 24; }
        ];
      };
      environment.systemPackages = [ pkgs.opensmtpd ];
      services.opensmtpd = {
        enable = true;
        extraServerArgs = [ "-v" ];
        serverConfiguration = ''
          listen on 0.0.0.0
          accept from any for local deliver to mda \
            "${pkgs.dovecot}/libexec/dovecot/deliver -d %{user.username}"
        '';
      };
      services.dovecot2 = {
        enable = true;
        enableImap = true;
        mailLocation = "maildir:~/mail";
        protocols = [ "imap" ];
      };
    };

    client = { pkgs, ... }: {
      networking = {
        useDHCP = false;
        interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = "192.168.1.3"; prefixLength = 24; }
        ];
      };
      environment.systemPackages = let
        sendTestMail = pkgs.writeScriptBin "send-a-test-mail" ''
          #!${pkgs.python3.interpreter}
          import smtplib, sys

          with smtplib.SMTP('192.168.1.1') as smtp:
            smtp.sendmail('alice@[192.168.1.1]', 'bob@[192.168.1.2]', """
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
            assert len(refs) == 1
            status, msg = imap.fetch(refs[0], 'BODY[TEXT]')
            assert status == 'OK'
            content = msg[0][1]
            print("===> content:", content)
            split = content.split(b'\r\n')
            print("===> split:", split)
            lastline = split[-3]
            print("===> lastline:", lastline)
            assert lastline.strip() == b'Hello World'
        '';
      in [ sendTestMail checkMailLanded ];
    };
  };

  testScript = ''
    startAll;

    $client->waitForUnit("network-online.target");
    $smtp1->waitForUnit('opensmtpd');
    $smtp2->waitForUnit('opensmtpd');
    $smtp2->waitForUnit('dovecot2');

    # To prevent sporadic failures during daemon startup, make sure
    # services are listening on their ports before sending requests
    $smtp1->waitForOpenPort(25);
    $smtp2->waitForOpenPort(25);
    $smtp2->waitForOpenPort(143);

    $client->succeed('send-a-test-mail');
    $smtp1->waitUntilFails('smtpctl show queue | egrep .');
    $smtp2->waitUntilFails('smtpctl show queue | egrep .');
    $client->succeed('check-mail-landed >&2');
  '';
}
