import ./make-test.nix {
  name = "dovecot";

  machine = { pkgs, ... }: {
    imports = [ common/user-account.nix ];
    services.postfix.enable = true;
    services.dovecot2.enable = true;
    services.dovecot2.protocols = [ "imap" "pop3" ];
    environment.systemPackages = let
      sendTestMail = pkgs.writeScriptBin "send-testmail" ''
        #!${pkgs.stdenv.shell}
        exec sendmail -vt <<MAIL
        From: root@localhost
        To: alice@localhost
        Subject: Very important!

        Hello world!
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
          pop.user('alice')
          pop.pass_('foobar')
          assert len(pop.list()[1]) == 1
          status, fullmail, size = pop.retr(1)
          assert status.startswith(b'+OK ')
          body = b"".join(fullmail[fullmail.index(b""):]).strip()
          assert body == b'Hello world!'
        finally:
          pop.quit()
      '';

    in [ sendTestMail testImap testPop ];
  };

  testScript = ''
    $machine->waitForUnit('postfix.service');
    $machine->waitForUnit('dovecot2.service');
    $machine->succeed('send-testmail');
    $machine->waitUntilFails('[ "$(postqueue -p)" != "Mail queue is empty" ]');
    $machine->succeed('test-imap');
    $machine->succeed('test-pop');
  '';
}
