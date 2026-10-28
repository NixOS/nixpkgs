# Minimal IMDSv2-compatible metadata server for NixOS EC2 tests.
# Runs in inetd mode (stdin/stdout), drop-in for micro_httpd in
# QEMU guestfwd and socat contexts.
{ pkgs }: pkgs.writers.writePython3Bin "imds-server" { } (builtins.readFile ./imds-server.py)
