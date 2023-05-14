import ../make-test-python.nix ({ pkgs, ... }:
let
  certs = import ../common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in {
  name = "maddy-tls";
  meta = with pkgs.lib.maintainers; { maintainers = [ onny ]; };

  nodes = {
    server = { options, ... }: {
      services.maddy = {
        enable = true;
        hostname = domain;
        primaryDomain = domain;
        openFirewall = true;
        ensureAccounts = [ "postmaster@${domain}" ];
        ensureCredentials = {
          # Do not use this in production. This will make passwords world-readable
          # in the Nix store
          "postmaster@${domain}".passwordFile = "${pkgs.writeText "postmaster" "test"}";
        };
        tls = {
          loader = "file";
          certificates = [{
            certPath = "${certs.${domain}.cert}";
            keyPath = "${certs.${domain}.key}";
          }];
        };
        submission.tlsEnable = true;
        imap.tlsEnable = true;
      };
    };

    client = { nodes, ... }: {
      security.pki.certificateFiles = [
        certs.ca.cert
      ];
      networking.extraHosts = ''
        ${nodes.server.networking.primaryIPAddress} ${domain}
     '';
      environment.systemPackages = [
        (pkgs.writers.writePython3Bin "send-testmail" { } ''
          import smtplib
          import ssl
          from email.mime.text import MIMEText

          context = ssl.create_default_context()
          msg = MIMEText("Hello World")
          msg['Subject'] = 'Test'
          msg['From'] = "postmaster@${domain}"
          msg['To'] = "postmaster@${domain}"
          with smtplib.SMTP_SSL(host='${domain}', port=465, context=context) as smtp:
              smtp.login('postmaster@${domain}', 'test')
              smtp.sendmail(
                'postmaster@${domain}', 'postmaster@${domain}', msg.as_string()
              )
        '')
        (pkgs.writers.writePython3Bin "test-imap" { } ''
          import imaplib

          with imaplib.IMAP4_SSL('${domain}') as imap:
              imap.login('postmaster@${domain}', 'test')
              imap.select()
              status, refs = imap.search(None, 'ALL')
              assert status == 'OK'
              assert len(refs) == 1
              status, msg = imap.fetch(refs[0], 'BODY[TEXT]')
              assert status == 'OK'
              assert msg[0][1].strip() == b"Hello World"
        '')
      ];
    };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("maddy.service")
    server.wait_for_open_port(143)
    server.wait_for_open_port(993)
    server.wait_for_open_port(587)
    server.wait_for_open_port(465)
    client.succeed("send-testmail")
    client.succeed("test-imap")
  '';
})
