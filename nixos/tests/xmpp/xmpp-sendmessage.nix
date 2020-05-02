{ writeScriptBin, writeText, python3, connectTo ? "localhost" }:
let
  dummyFile = writeText "dummy-file" ''
    Dear dog,

    Please find this *really* important attachment.

    Yours truly,
    John
  '';
in writeScriptBin "send-message" ''
#!${(python3.withPackages (ps: [ ps.slixmpp ])).interpreter}
import logging
import sys
from types import MethodType

from slixmpp import ClientXMPP
from slixmpp.exceptions import IqError, IqTimeout


class CthonTest(ClientXMPP):

    def __init__(self, jid, password):
        ClientXMPP.__init__(self, jid, password)
        self.add_event_handler("session_start", self.session_start)

    async def session_start(self, event):
        log = logging.getLogger(__name__)
        self.send_presence()
        self.get_roster()
        # Sending a test message
        self.send_message(mto="azurediamond@example.com", mbody="Hello, this is dog.", mtype="chat")
        log.info('Message sent')

        # Test http upload (XEP_0363)
        def timeout_callback(arg):
            log.error("ERROR: Cannot upload file. XEP_0363 seems broken")
            sys.exit(1)
        url = await self['xep_0363'].upload_file("${dummyFile}",timeout=10, timeout_callback=timeout_callback)
        log.info('Upload success!')
        # Test MUC
        self.plugin['xep_0045'].join_muc('testMucRoom', 'cthon98', wait=True)
        log.info('MUC join success!')
        log.info('XMPP SCRIPT TEST SUCCESS')
        self.disconnect(wait=True)


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG,
                        format='%(levelname)-8s %(message)s')

    ct = CthonTest('cthon98@example.com', 'nothunter2')
    ct.register_plugin('xep_0071')
    ct.register_plugin('xep_0128')
    # HTTP Upload
    ct.register_plugin('xep_0363')
    # MUC
    ct.register_plugin('xep_0045')
    ct.connect(("server", 5222))
    ct.process(forever=False)
''
