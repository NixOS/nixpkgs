{ writeScriptBin, writeText, python3, connectTo ? "localhost" }:
let
  dummyFile = writeText "dummy-file" ''
    Dear dog,

    Please find this *really* important attachment.

    Yours truly,
    Bob
  '';
in writeScriptBin "send-message" ''
#!${(python3.withPackages (ps: [ ps.slixmpp ])).interpreter}
import logging
import sys
import signal
from types import MethodType

from slixmpp import ClientXMPP
from slixmpp.exceptions import IqError, IqTimeout


class CthonTest(ClientXMPP):

    def __init__(self, jid, password):
        ClientXMPP.__init__(self, jid, password)
        self.add_event_handler("session_start", self.session_start)
        self.test_succeeded = False

    async def session_start(self, event):
        try:
            # Exceptions in event handlers are printed to stderr but not
            # propagated, they do not make the script terminate with a non-zero
            # exit code. We use the `test_succeeded` flag as a workaround and
            # check it later at the end of the script to exit with a proper
            # exit code.
            # Additionally, this flag ensures that this event handler has been
            # actually run by ClientXMPP, which may well not be the case.
            await self.test_xmpp_server()
            self.test_succeeded = True
        finally:
            # Even if an exception happens in `test_xmpp_server()`, we still
            # need to disconnect explicitly, otherwise the process will hang
            # forever.
            self.disconnect(wait=True)

    async def test_xmpp_server(self):
        log = logging.getLogger(__name__)
        self.send_presence()
        self.get_roster()
        # Sending a test message
        self.send_message(mto="azurediamond@example.com", mbody="Hello, this is dog.", mtype="chat")
        log.info('Message sent')

        # Test http upload (XEP_0363)
        try:
            url = await self['xep_0363'].upload_file("${dummyFile}",timeout=10)
        except:
            log.error("ERROR: Cannot run upload command. XEP_0363 seems broken")
            sys.exit(1)
        log.info('Upload success!')

        # Test MUC
        # TODO: use join_muc_wait() after slixmpp 1.8.0 is released.
        self.plugin['xep_0045'].join_muc('testMucRoom', 'cthon98')
        log.info('MUC join success!')
        log.info('XMPP SCRIPT TEST SUCCESS')

def timeout_handler(signalnum, stackframe):
    print('ERROR: xmpp-sendmessage timed out')
    sys.exit(1)

if __name__ == '__main__':
    signal.signal(signal.SIGALRM, timeout_handler)
    signal.alarm(120)
    logging.basicConfig(level=logging.DEBUG,
                        format='%(levelname)-8s %(message)s')

    ct = CthonTest('cthon98@example.com', 'nothunter2')
    ct.register_plugin('xep_0071')
    ct.register_plugin('xep_0128')
    # HTTP Upload
    ct.register_plugin('xep_0363')
    # MUC
    ct.register_plugin('xep_0045')
    ct.connect(("${connectTo}", 5222))
    ct.process(forever=False)

    if not ct.test_succeeded:
        sys.exit(1)
''
