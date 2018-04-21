import ./make-test.nix {
  name = "prosody";

  machine = { config, pkgs, ... }: {
    services.prosody = {
      enable = true;
      # TODO: use a self-signed certificate
      c2sRequireEncryption = false;
    };
    environment.systemPackages = let
      sendMessage = pkgs.writeScriptBin "send-message" ''
        #!/usr/bin/env python3
        # Based on the sleekxmpp send_client example, look there for more details:
        # https://github.com/fritzy/SleekXMPP/blob/develop/examples/send_client.py
        import sleekxmpp

        class SendMsgBot(sleekxmpp.ClientXMPP):
            """
            A basic SleekXMPP bot that will log in, send a message,
            and then log out.
            """
            def __init__(self, jid, password, recipient, message):
                sleekxmpp.ClientXMPP.__init__(self, jid, password)

                self.recipient = recipient
                self.msg = message

                self.add_event_handler("session_start", self.start, threaded=True)

            def start(self, event):
                self.send_presence()
                self.get_roster()

                self.send_message(mto=self.recipient,
                                  mbody=self.msg,
                                  mtype='chat')

                self.disconnect(wait=True)


        if __name__ == '__main__':
            xmpp = SendMsgBot("test1@localhost", "test1", "test2@localhost", "Hello World!")
            xmpp.register_plugin('xep_0030') # Service Discovery
            xmpp.register_plugin('xep_0199') # XMPP Ping

            # TODO: verify certificate
            # If you want to verify the SSL certificates offered by a server:
            # xmpp.ca_certs = "path/to/ca/cert"

            if xmpp.connect(('localhost', 5222)):
                xmpp.process(block=True)
            else:
                print("Unable to connect.")
                sys.exit(1)
      '';
    in [ (pkgs.python3.withPackages (ps: [ ps.sleekxmpp ])) sendMessage ];
  };

  testScript = ''
    $machine->waitForUnit('prosody.service');
    $machine->succeed('prosodyctl status') =~ /Prosody is running/;

    # set password to 'test' (it's asked twice)
    $machine->succeed('yes test1 | prosodyctl adduser test1@localhost');
    # set password to 'y'
    $machine->succeed('yes | prosodyctl adduser test2@localhost');
    # correct password to 'test2'
    $machine->succeed('yes test2 | prosodyctl passwd test2@localhost');

    $machine->succeed("send-message");

    $machine->succeed('prosodyctl deluser test1@localhost');
    $machine->succeed('prosodyctl deluser test2@localhost');
  '';
}
