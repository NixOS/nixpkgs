#!/usr/bin/env python3

import os
import sys

from flask.cli import main


os.environ.setdefault("FLASK_APP", "listenbrainz.webserver:create_web_app()")

if len(sys.argv) == 1:
    sys.argv.extend(["run", "--host", "127.0.0.1", "--port", "8100"])

main()
