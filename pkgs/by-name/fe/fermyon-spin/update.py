#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 bash nix-update jq
import subprocess
from os.path import join, dirname

# Outer keys are as in Nix, the inner dict's values are as in upstream.
# We set oldHash and newHash fields in the inner dict later.
systems = {
  "x86_64-linux": {"os": "linux", "arch": "amd64"},
  "x86_64-darwin": {"os": "macos", "arch": "amd64"},
  "aarch64-linux": {"os": "linux", "arch": "aarch64"},
  "aarch64-darwin": {"os": "macos", "arch": "aarch64"},
}

# This will set the version correctly,
# and will also set the hash for one of the systems.
subprocess.run([
  "nix-update",
  "fermyon-spin",
  "--version-regex",
  r"^v([\d\.]*)",
  "--url",
  "https://github.com/spinframework/spin"
])

newVer = subprocess.run(
  ["nix-instantiate", "--eval", "--raw", "-A", "fermyon-spin.version"], capture_output=True, encoding="locale"
).stdout

for nixTuple in systems:
  url = (
    "https://github.com/spinframework/spin/releases/download/v"
    f"{newVer}/spin-v{newVer}-{systems[nixTuple]['os']}-{systems[nixTuple]['arch']}.tar.gz"
  )

  systems[nixTuple]["oldHash"] = subprocess.run(
    ["nix-instantiate", "--eval", "--raw", "-A", f"fermyon-spin.passthru.packageHashes.{nixTuple}"],
    capture_output=True,
    encoding="locale",
  ).stdout

  systems[nixTuple]["newHash"] = subprocess.run(
    ["bash", "-c", f"nix store prefetch-file {url} --json | jq -r '.hash'"],
    capture_output=True,
    encoding="locale",
  ).stdout.strip()  # Has a newline

with open(join(dirname(__file__), "package.nix"), "r") as f:
  file = f.read()

for nixTuple in systems:
  file = file.replace(systems[nixTuple]["oldHash"], systems[nixTuple]["newHash"])

with open(join(dirname(__file__), "package.nix"), "w") as f:
  f.write(file)
