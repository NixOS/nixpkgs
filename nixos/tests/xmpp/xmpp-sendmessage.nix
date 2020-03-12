{ writeScriptBin, python3, connectTo ? "localhost" }:
writeScriptBin "send-message" ''
  #!${(python3.withPackages (ps: [ ps.sleekxmpp ])).interpreter}
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
      xmpp = SendMsgBot("cthon98@example.com", "nothunter2", "azurediamond@example.com", "hey, if you type in your pw, it will show as stars")
      xmpp.register_plugin('xep_0030') # Service Discovery
      xmpp.register_plugin('xep_0199') # XMPP Ping

      # TODO: verify certificate
      # If you want to verify the SSL certificates offered by a server:
      # xmpp.ca_certs = "path/to/ca/cert"

      if xmpp.connect(('${connectTo}', 5222)):
          xmpp.process(block=True)
      else:
          print("Unable to connect.")
          sys.exit(1)
''
