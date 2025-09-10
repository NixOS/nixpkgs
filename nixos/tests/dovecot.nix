{
  name = "dovecot";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ common/user-account.nix ];
      services.postfix.enable = true;
      services.dovecot2 = {
        enable = true;
        protocols = [
          "imap"
          "pop3"
        ];
        mailUser = "vmail";
        mailGroup = "vmail";
      };
      environment.systemPackages =
        let
          sendTestMail = pkgs.writeScriptBin "send-testmail" ''
            #!${pkgs.runtimeShell}
            exec sendmail -vt <<MAIL
            From: root@localhost
            To: alice@localhost
            Subject: Very important!

            Hello world!
            MAIL
          '';

          sendTestMailViaDeliveryAgent = pkgs.writeScriptBin "send-lda" ''
            #!${pkgs.runtimeShell}

            exec ${pkgs.dovecot}/libexec/dovecot/deliver -d bob <<MAIL
            From: root@localhost
            To: bob@localhost
            Subject: Something else...

            I'm running short of ideas!
            MAIL
          '';

          testImap = pkgs.writeScriptBin "test-imap" ''
            #!${pkgs.python3.interpreter}
            import imaplib

            with imaplib.IMAP4('localhost') as imap:
              imap.login('alice', 'foobar')
              imap.select()
              status, refs = imap.search(None, 'ALL')
              assert status == 'OK'
              assert len(refs) == 1
              status, msg = imap.fetch(refs[0], 'BODY[TEXT]')
              assert status == 'OK'
              assert msg[0][1].strip() == b'Hello world!'
          '';

          testPop = pkgs.writeScriptBin "test-pop" ''
            #!${pkgs.python3.interpreter}
            import poplib

            pop = poplib.POP3('localhost')
            try:
              pop.user('bob')
              pop.pass_('foobar')
              assert len(pop.list()[1]) == 1
              status, fullmail, size = pop.retr(1)
              assert status.startswith(b'+OK ')
              body = b"".join(fullmail[fullmail.index(b""):]).strip()
              assert body == b"I'm running short of ideas!"
            finally:
              pop.quit()
          '';

        in
        [
          pkgs.dovecot_pigeonhole
          sendTestMail
          sendTestMailViaDeliveryAgent
          testImap
          testPop
        ];
    };

  testScript = ''
    machine.wait_for_unit("postfix.service")
    machine.wait_for_unit("dovecot.service")
    machine.succeed("send-testmail")
    machine.succeed("send-lda")
    machine.wait_until_fails('[ "$(postqueue -p)" != "Mail queue is empty" ]')
    machine.succeed("test-imap")
    machine.succeed("test-pop")

    machine.log(machine.succeed("systemd-analyze security dovecot.service | grep -v ✓"))
  '';
}
