import ./make-test.nix {
  name = "opensmtpd";

  nodes = {
    server = { pkgs, ... }: {
      imports = [ common/user-account.nix ];
      services.nginx = {
        enable = true;
        virtualHosts."127.0.0.1".root = ./common/webroot;
      };
      services.rss2email = {
        enable = true;
        to = "alice@localhost";
        interval = "1";
        config.from = "test@example.org";
        feeds = {
          nixos = { url = "http://127.0.0.1/news-rss.xml"; };
        };
      };
      services.opensmtpd = {
        enable = true;
        extraServerArgs = [ "-v" ];
        serverConfiguration = ''
          listen on 127.0.0.1
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
      environment.systemPackages = let
        checkMailLanded = pkgs.writeScriptBin "check-mail-landed" ''
          #!${pkgs.python3.interpreter}
          import imaplib

          with imaplib.IMAP4('127.0.0.1', 143) as imap:
            imap.login('alice', 'foobar')
            imap.select()
            status, refs = imap.search(None, 'ALL')
            print("=====> Result of search for all:", status, refs)
            assert status == 'OK'
            assert len(refs) > 0
            status, msg = imap.fetch(refs[0], 'BODY[TEXT]')
            assert status == 'OK'
        '';
      in [ pkgs.opensmtpd checkMailLanded ];
    };
  };

  testScript = ''
    startAll;

    $server->waitForUnit("network-online.target");
    $server->waitForUnit("opensmtpd");
    $server->waitForUnit("dovecot2");
    $server->waitForUnit("nginx");
    $server->waitForUnit("rss2email");

    $server->waitUntilSucceeds('check-mail-landed >&2');
  '';
}
