from systemd.daemon import notify
import argparse
import logging
import os
import subprocess
import socket
import sys
import time


logging.basicConfig(level=logging.INFO, format='%(message)s')


def wait_for_port(host, port, timeout=10):
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            with socket.create_connection((host, port), timeout=0.5):
                return True
        except Exception:
            time.sleep(0.1)
    return False


def flatten(xss):
    return [x for xs in xss for x in xs]


parser = argparse.ArgumentParser()
parser.add_argument("--listen_host", default="127.0.0.1", help="Host mitmdump will listen on")
parser.add_argument("--listen_port", required=True, help="Port mitmdump will listen on")
parser.add_argument("--upstream_host", default="http://127.0.0.1", help="Host mitmdump will connect to for upstream. Example: http://127.0.0.1 or https://otherhost")
parser.add_argument("--upstream_port", required=True, help="Port mitmdump will connect to for upstream")
args, rest = parser.parse_known_args()

MITMDUMP_BIN = os.environ.get("MITMDUMP_BIN")
if MITMDUMP_BIN is None:
    raise Exception("MITMDUMP_BIN env var must be set to the path of the mitmdump binary")

logging.info(f"Waiting for upstream address '{args.upstream_host}:{args.upstream_port}' to be up.")
wait_for_port(args.upstream_host, args.upstream_port, timeout=10)
logging.info(f"Upstream address '{args.upstream_host}:{args.upstream_port}' is up.")

proc = subprocess.Popen(
    [
        MITMDUMP_BIN,
        "--listen-host", args.listen_host,
        "-p", args.listen_port,
        "--mode", f"reverse:{args.upstream_host}:{args.upstream_port}",
    ] + rest,
    stdout=sys.stdout,
    stderr=sys.stderr,
)

logging.info(f"Waiting for mitmdump instance to start on port {args.listen_port}.")
if wait_for_port("127.0.0.1", args.listen_port, timeout=10):
    logging.info(f"Mitmdump is started on port {args.listen_port}.")
    notify("READY=1")
else:
    proc.terminate()
    exit(1)

proc.wait()
