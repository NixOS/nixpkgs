import ../make-test-python.nix ({ pkgs, ... }: {
  name = "maddy-unencrypted";
  meta = with pkgs.lib.maintainers; { maintainers = [ onny ]; };

  nodes = {
    server = { ... }: {
      services.maddy = {
        enable = true;
        hostname = "server";
        primaryDomain = "server";
        openFirewall = true;
        ensureAccounts = [ "postmaster@server" ];
        ensureCredentials = {
          # Do not use this in production. This will make passwords world-readable
          # in the Nix store
          "postmaster@server".passwordFile = "${pkgs.writeText "postmaster" "test"}";
        };
      };
    };

    client = { ... }: {
      environment.systemPackages = [
        (pkgs.writers.writePython3Bin "send-testmail" { } ''
          import smtplib
          from email.mime.text import MIMEText

          msg = MIMEText("Hello World")
          msg['Subject'] = 'Test'
          msg['From'] = "postmaster@server"
          msg['To'] = "postmaster@server"
          with smtplib.SMTP('server', 587) as smtp:
              smtp.login('postmaster@server', 'test')
              smtp.sendmail('postmaster@server', 'postmaster@server', msg.as_string())
        '')
        (pkgs.writers.writePython3Bin "test-imap" { } ''
          import imaplib

          with imaplib.IMAP4('server') as imap:
              imap.login('postmaster@server', 'test')
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
    server.wait_for_open_port(587)
    client.succeed("send-testmail")
    client.succeed("test-imap")
  '';
})
