#!/usr/bin/env python3
import json
import sys
import time
import os
import hashlib
import base64

from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs
from typing import Dict

SNAKEOIL_PUBLIC_KEY = os.environ['SNAKEOIL_PUBLIC_KEY']
MOCKUSER="mockuser_nixos_org"
MOCKADMIN="mockadmin_nixos_org"


def w(msg: bytes):
    sys.stderr.write(f"{msg}\n")
    sys.stderr.flush()


def gen_fingerprint(pubkey: str):
    decoded_key = base64.b64decode(pubkey.encode("ascii").split()[1])
    return hashlib.sha256(decoded_key).hexdigest()


def gen_email(username: str):
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

    def _send_json_ok(self, data: dict):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        out = json.dumps(data).encode()
        w(out)
        self.wfile.write(out)

    def _send_json_success(self, success=True):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        out = json.dumps({"success": success}).encode()
        w(out)
        self.wfile.write(out)

    def _send_404(self):
        self.send_response(404)
        self.end_headers()

    def do_GET(self):
        p = str(self.path)
        pu = urlparse(p)
        params = parse_qs(pu.query)

        # users endpoint
        if pu.path == "/computeMetadata/v1/oslogin/users":
            # mockuser and mockadmin are allowed to login, both use the same snakeoil public key
            if params.get('username') == [MOCKUSER] or params.get('uid') == ["1009719690"]:
                username = MOCKUSER
                uid = "1009719690"
            elif params.get('username') == [MOCKADMIN] or params.get('uid') == ["1009719691"]:
                username = MOCKADMIN
                uid = "1009719691"
            else:
                self._send_404()
                return

            self._send_json_ok(gen_mockuser(username=username, uid=uid, gid=uid, home_directory=f"/home/{username}", snakeoil_pubkey=SNAKEOIL_PUBLIC_KEY))
            return

        # authorize endpoint
        elif pu.path == "/computeMetadata/v1/oslogin/authorize":
            # is user allowed to login?
            if params.get("policy") == ["login"]:
                # mockuser and mockadmin are allowed to login
                if params.get('email') == [gen_email(MOCKUSER)] or params.get('email') == [gen_email(MOCKADMIN)]:
                    self._send_json_success()
                    return
                self._send_json_success(False)
                return
            # is user allowed to become root?
            elif params.get("policy") == ["adminLogin"]:
                # only mockadmin is allowed to become admin
                self._send_json_success((params['email'] == [gen_email(MOCKADMIN)]))
                return
            # send 404 for other policies
            else:
                self._send_404()
                return
        else:
            sys.stderr.write(f"Unhandled path: {p}\n")
            sys.stderr.flush()
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'')


if __name__ == '__main__':
    s = HTTPServer(('0.0.0.0', 80), ReqHandler)
    s.serve_forever()
