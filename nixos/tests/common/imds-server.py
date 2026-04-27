"""Minimal IMDSv2-compatible metadata server for NixOS EC2 tests.

Runs in inetd mode: reads one HTTP request from stdin, writes the
response to stdout. Drop-in replacement for micro_httpd in QEMU
guestfwd and socat contexts.

Usage: imds-server <metadata-directory>

The metadata directory should contain:
  latest/api/token                        - Token value (returned on PUT)
  1.0/meta-data/hostname                  - Instance hostname
  1.0/meta-data/ami-manifest-path         - AMI manifest path
  1.0/meta-data/instance-id               - Instance ID
  1.0/meta-data/public-keys/0/openssh-key - SSH public key
  1.0/user-data                           - User data
"""

import os
import sys


def read_request():
    """Read and parse one HTTP request from stdin (inetd mode)."""
    request_line = sys.stdin.readline()
    if not request_line:
        sys.exit(0)

    parts = request_line.strip().split()
    method = parts[0] if parts else ""
    path = parts[1] if len(parts) > 1 else "/"

    headers = {}
    while True:
        line = sys.stdin.readline()
        if not line or line.strip() == "":
            break
        if ":" in line:
            key, _, value = line.partition(":")
            headers[key.strip().lower()] = value.strip()

    return method, path, headers


def respond(status, body):
    """Write an HTTP response to stdout."""
    if isinstance(body, str):
        body = body.encode()
    header = (
        f"HTTP/1.1 {status}\r\n"
        f"Content-Type: text/plain\r\n"
        f"Content-Length: {len(body)}\r\n"
        f"Connection: close\r\n"
        f"\r\n"
    ).encode()
    sys.stdout.buffer.write(header + body)
    sys.stdout.buffer.flush()


def main():
    base_dir = sys.argv[1] if len(sys.argv) > 1 else "."

    # Load expected token from file. If no token file exists, IMDSv2
    # authentication is disabled — requests are served without tokens.
    # This supports both EC2 (IMDSv2 with tokens) and OpenStack (plain GET)
    # metadata fetchers.
    token_path = os.path.join(base_dir, "latest", "api", "token")
    if os.path.isfile(token_path):
        with open(token_path) as f:
            expected_token = f.read().strip()
    else:
        expected_token = None

    method, path, headers = read_request()
    rel_path = path.lstrip("/")

    # PUT /latest/api/token — IMDSv2 token acquisition
    if method == "PUT" and rel_path == "latest/api/token":
        if expected_token is not None:
            respond("200 OK", expected_token)
        else:
            respond("404 Not Found", "IMDSv2 token endpoint not configured\n")
        return

    # Token validation (only when a token file is present)
    if expected_token is not None:
        request_token = headers.get("x-aws-ec2-metadata-token", "")
        if request_token != expected_token:
            respond("401 Unauthorized", "Invalid or missing IMDSv2 token\n")
            return

    # Serve file from the metadata directory
    file_path = os.path.join(base_dir, rel_path)
    if os.path.isfile(file_path):
        with open(file_path, "rb") as f:
            content = f.read()
        respond("200 OK", content)
    else:
        respond("404 Not Found", f"Not found: {path}\n")


if __name__ == "__main__":
    main()
