import ./make-test-python.nix {
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
          action do_relay relay
          # DO NOT DO THIS IN PRODUCTION!
          # Setting up authentication requires a certificate which is painful in
          # a test environment, but THIS WOULD BE DANGEROUS OUTSIDE OF A
          # WELL-CONTROLLED ENVIRONMENT!
          match from any for any action do_relay
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

    smtp3 = { pkgs, config, lib, nodes, ... }: {
      imports = [ common/user-account.nix common/acme/client ];
      networking = {
        firewall.allowedTCPPorts = [ 25 80 443 ];
        useDHCP = false;
        # TODO investigate why primaryIPAddress is wrong by default
        primaryIPAddress = lib.mkOverride 0 "192.168.1.3";
        interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = "192.168.1.3"; prefixLength = 24; }
        ];
        nameservers = [ nodes.acme.config.networking.primaryIPAddress ];
        # common/resolver.nix parses extraHosts and adds DNS records
        extraHosts = ''
          127.0.0.1 example.test
          ${config.networking.primaryIPAddress} example.test
        '';
      };
      environment.systemPackages = [ pkgs.opensmtpd pkgs.openssl ];
      services.opensmtpd = {
        enable = true;
        useACMEHosts = [ "example.test" ];
        extraServerArgs = [ "-v" ];
        serverConfiguration = ''
          listen on 0.0.0.0 tls pki example.test
          action do_relay relay
          # DO NOT DO THIS IN PRODUCTION!
          # Setting up authentication requires a certificate which is painful in
          # a test environment, but THIS WOULD BE DANGEROUS OUTSIDE OF A
          # WELL-CONTROLLED ENVIRONMENT!
          match from any for any action do_relay
        '';
      };

      # Will need a web server to perform cert renewal
      # First tests configure a basic cert and run a bunch of openssl checks
      services.nginx.enable = true;
      services.nginx.virtualHosts."example.test" = {
        forceSSL = true;
        enableACME = true;
        locations."/".root = pkgs.runCommand "docroot" {} ''
          mkdir -p "$out"
          echo hello world > "$out/index.html"
        '';
      };
    };

    # The fake ACME server which will respond to client requests
    acme = { lib, ... }: {
      imports = [ common/acme/server ];
      networking = {
        useDHCP = false;
        # TODO investigate why primaryIPAddress is wrong by default
        primaryIPAddress = lib.mkOverride 0 "192.168.1.4";
        interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [
          { address = "192.168.1.4"; prefixLength = 24; }
        ];
      };
    };

    client = { pkgs, ... }: {
      networking = {
        useDHCP = false;
        interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = "192.168.1.5"; prefixLength = 24; }
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

  testScript = {nodes, ...}:
  let
    caDomain = nodes.acme.config.test-support.acme.caDomain;
  in ''
    import time


    def download_ca_certs(node, retries=5):
      assert retries >= 0, "Failed to connect to pebble to download root CA certs"

      exit_code, _ = node.execute("curl https://${caDomain}:15000/roots/0 > /tmp/ca.crt")
      exit_code_2, _ = node.execute(
          "curl https://${caDomain}:15000/intermediate-keys/0 >> /tmp/ca.crt"
      )

      if exit_code + exit_code_2 > 0:
          time.sleep(3)
          return download_ca_certs(node, retries - 1)


    acme.start()
    acme.wait_for_open_port(443)
    acme.wait_for_open_port(53)
    acme.succeed("host example.test 127.0.0.1 | grep 192.168.1.3")
    acme.succeed("host ${caDomain} 127.0.0.1 | grep 192.168.1.4")

    start_all()

    client.systemctl("start network-online.target")
    client.wait_for_unit("network-online.target")
    smtp1.wait_for_unit("opensmtpd")
    smtp2.wait_for_unit("opensmtpd")
    smtp2.wait_for_unit("dovecot2")
    smtp3.wait_for_unit("opensmtpd")

    # To prevent sporadic failures during daemon startup, make sure
    # services are listening on their ports before sending requests
    smtp1.wait_for_open_port(25)
    smtp2.wait_for_open_port(25)
    smtp2.wait_for_open_port(143)
    smtp3.wait_for_open_port(25)

    # Test SSL certificate configuration
    download_ca_certs(smtp3)
    smtp3.succeed(
        "echo | openssl s_client -starttls smtp -connect localhost:25 -CAfile /tmp/ca.crt"
        " -verify 3 -servername example.test 2>&1 | awk '/verify error/ { print $0; exit 1 }'"
    )

    client.succeed("send-a-test-mail")
    smtp1.wait_until_fails("smtpctl show queue | egrep .")
    smtp2.wait_until_fails("smtpctl show queue | egrep .")
    client.succeed("check-mail-landed >&2")
  '';

  meta.timeout = 1800;
}
