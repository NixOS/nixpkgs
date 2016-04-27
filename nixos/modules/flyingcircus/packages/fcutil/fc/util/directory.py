"""Unified client access to fc.directory."""

import contextlib
import json
import xmlrpc.client


DIRECTORY_URL_RING0 = (
    'https://{enc[name]}:{enc[parameters][directory_password]}@'
    'directory.fcio.net/v2/api')

DIRECTORY_URL_RING1 = (
    'https://{enc[name]}:{enc[parameters][directory_password]}@'
    'directory.fcio.net/v2/api/rg-{enc[parameters][resource_group]}')


def load_default_enc_json():
    with open('/etc/nixos/enc.json') as f:
        return json.load(f)


def connect(enc_data=None, ring=1):
    """Returns XML-RPC directory connection.

    The directory secret is read from `/etc/nixos/enc.json`.
    Alternatively, the parsed JSON content can be passed directly as
    dict.

    Selects ring0/ring1 API according to the `ring` parameter.
    """
    if not enc_data:
        enc_data = load_default_enc_json()
    url = {0: DIRECTORY_URL_RING0,
           1: DIRECTORY_URL_RING1}[ring]
    return xmlrpc.client.Server(url.format(enc=enc_data), allow_none=True,
                                use_datetime=True)


@contextlib.contextmanager
def directory_connection(enc_path):
    """Execute the associated block with a directory connection."""
    enc_data = None
    if enc_path:
        with open(enc_path) as f:
            enc_data = json.load(f)
    yield fc.util.directory.connect(enc_data)
