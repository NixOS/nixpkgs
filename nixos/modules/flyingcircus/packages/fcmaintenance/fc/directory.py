import json
import xmlrpc


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
    if not enc_data:
        enc_data = load_default_enc_json()
    url = {0: DIRECTORY_URL_RING0,
           1: DIRECTORY_URL_RING1}[ring]
    return xmlrpc.client.Server(url.format(enc=enc_data), allow_none=True,
                                use_datetime=True)
