#!/usr/bin/env python3
import json
import sys
import time
import os
import hashlib
import base64

from http.server import BaseHTTPRequestHandler, HTTPServer
from typing import Dict

SNAKEOIL_PUBLIC_KEY = os.environ['SNAKEOIL_PUBLIC_KEY']


def w(msg):
    sys.stderr.write(f"{msg}\n")
    sys.stderr.flush()


def gen_fingerprint(pubkey):
    decoded_key = base64.b64decode(pubkey.encode("ascii").split()[1])
    return hashlib.sha256(decoded_key).hexdigest()

def gen_email(username):
    """username seems to be a 21 characters long number string, so mimic that in a reproducible way"""
    return str(int(hashlib.sha256(username.encode()).hexdigest(), 16))[0:21]

def gen_mockuser(username: str, uid: str, gid: str, home_directory: str, snakeoil_pubkey: str) -> Dict:
    snakeoil_pubkey_fingerprint = gen_fingerprint(snakeoil_pubkey)
    # seems to be a 21 characters long numberstring, so mimic that in a reproducible way
    email = gen_email(username)
    return {
        "loginProfiles": [
            {
                "name": email,
                "posixAccounts": [
                    {
                        "primary": True,
                        "username": username,
                        "uid": uid,
                        "gid": gid,
                        "homeDirectory": home_directory,
                        "operatingSystemType": "LINUX"
                    }
                ],
                "sshPublicKeys": {
                    snakeoil_pubkey_fingerprint: {
                        "key": snakeoil_pubkey,
                        "expirationTimeUsec": str((time.time() + 600) * 1000000),  # 10 minutes in the future
                        "fingerprint": snakeoil_pubkey_fingerprint
                    }
                }
            }
        ]
    }


class ReqHandler(BaseHTTPRequestHandler):
    def _send_json_ok(self, data):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        out = json.dumps(data).encode()
        w(out)
        self.wfile.write(out)

    def do_GET(self):
        p = str(self.path)
        # mockuser and mockadmin are allowed to login, both use the same snakeoil public key
        if p == '/computeMetadata/v1/oslogin/users?username=mockuser' \
            or p == '/computeMetadata/v1/oslogin/users?uid=1009719690':
            self._send_json_ok(gen_mockuser(username='mockuser', uid='1009719690', gid='1009719690',
                                            home_directory='/home/mockuser', snakeoil_pubkey=SNAKEOIL_PUBLIC_KEY))
        elif p == '/computeMetadata/v1/oslogin/users?username=mockadmin' \
            or p == '/computeMetadata/v1/oslogin/users?uid=1009719691':
            self._send_json_ok(gen_mockuser(username='mockadmin', uid='1009719691', gid='1009719691',
                                            home_directory='/home/mockadmin', snakeoil_pubkey=SNAKEOIL_PUBLIC_KEY))

        # mockuser is allowed to login
        elif p == f"/computeMetadata/v1/oslogin/authorize?email={gen_email('mockuser')}&policy=login":
            self._send_json_ok({'success': True})

        # mockadmin may also become root
        elif p == f"/computeMetadata/v1/oslogin/authorize?email={gen_email('mockadmin')}&policy=login" or p == f"/computeMetadata/v1/oslogin/authorize?email={gen_email('mockadmin')}&policy=adminLogin":
            self._send_json_ok({'success': True})
        else:
            sys.stderr.write(f"Unhandled path: {p}\n")
            sys.stderr.flush()
            self.send_response(501)
            self.end_headers()
            self.wfile.write(b'')


if __name__ == '__main__':
    s = HTTPServer(('0.0.0.0', 80), ReqHandler)
    s.serve_forever()
