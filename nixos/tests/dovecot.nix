import ./make-test-python.nix {
  name = "dovecot";

  nodes.machine = { pkgs, ... }: {
    imports = [ common/user-account.nix ];
    users.users.timmy = {
      isNormalUser = true;
      description = "Timmy Foobar";
      password = "foobar";
    };
    services.postfix = {
      enable = true;
      rootAlias = "timmy";
      extraConfig = "mailbox_transport = lmtp:unix:/var/run/dovecot2/lmtp";
    };
    services.dovecot2 = {
      enable = true;
      protocols = [ "imap" "pop3" "lmtp" "sieve" ];
      modules = [ pkgs.dovecot_pigeonhole ];
      mailUser = "vmail";
      mailGroup = "vmail";
      mailboxes.Junk = {
        specialUse = "Junk";
        auto = "subscribe";
      };
      extraConfig = ''
        mail_debug = yes

        protocol lmtp {
          postmaster_address = root@localhost
          auth_username_format = %n
          mail_plugins = $mail_plugins sieve
        }
      '';
      sieveScripts.before = pkgs.writeText "before.sieve" ''
        require "fileinto";
        if header :is "X-Spam" "Yes" {
          fileinto "Junk";
          stop;
        }
      '';
    };
    environment.systemPackages = let
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

      sendTestMail2 = pkgs.writeScriptBin "send-testmail2" ''
        #!${pkgs.runtimeShell}

        exec sendmail -vt <<MAIL
        From: root@localhost
        To: alice@localhost
        Subject: Very spammy!
        X-Spam: Yes

        This is spam!
        MAIL
      '';

      testImap = pkgs.writeScriptBin "test-imap" ''
        #!${pkgs.python3.interpreter}
        import imaplib

        with imaplib.IMAP4('localhost') as imap:
          imap.login('alice', 'foobar')
          imap.select()
          status, data = imap.search(None, 'ALL')
          assert status == 'OK'
          assert len(data) == 1
          refs = data[0].split()
          print(refs)
          for num in refs:
            status, msg = imap.fetch(num, 'BODY[TEXT]')
            print(msg[0][1].decode("utf-8"))
          assert len(refs) == 1
          status, msg = imap.fetch(refs[0], 'BODY[TEXT]')
          assert status == 'OK'
          assert msg[0][1].strip() == b'Hello world!'

          imap.select(mailbox='Junk')
          status, data = imap.search(None, 'ALL')
          assert status == 'OK'
          assert len(data) == 1
          refs = data[0].split()
          print(refs)
          for num in refs:
            status, msg = imap.fetch(num, 'BODY[TEXT]')
            print(msg[0][1].decode("utf-8"))
          assert len(refs) == 1
          status, msg = imap.fetch(refs[0], 'BODY[TEXT]')
          assert status == 'OK'
          assert msg[0][1].strip() == b'This is spam!'
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
    in [ sendTestMail sendTestMailViaDeliveryAgent sendTestMail2 testImap testPop ];
  };
  testScript = ''
    machine.wait_for_unit("postfix.service")
    machine.wait_for_unit("dovecot2.service")
    machine.succeed("send-testmail")
    machine.succeed("send-lda")
    machine.succeed("send-testmail2")
    machine.wait_until_fails('[ "$(postqueue -p)" != "Mail queue is empty" ]')
    machine.succeed("test-imap")
    machine.succeed("test-pop")
  '';
}
