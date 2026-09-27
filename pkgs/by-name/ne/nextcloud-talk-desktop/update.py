#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 bash nix-update jq

import subprocess
from os.path import join, dirname

# This will set the version correctly,
# and will also set the hash for x86_64-linux.
subprocess.run(["nix-update", "nextcloud-talk-desktop"])

# Now get the hash for Darwin.
# (It's the same for both Darwin platforms, and we don't support aarch64-linux).
newVer = subprocess.run(
  ["nix-instantiate", "--eval", "--raw", "-A", "nextcloud-talk-desktop.version"], capture_output=True, encoding="locale"
).stdout

darwinUrl = (
  f"https://github.com/nextcloud-releases/talk-desktop/releases/download/v{newVer}/Nextcloud.Talk-macos-universal.dmg"
)

oldDarwinHash = subprocess.run(
  ["nix-instantiate", "--eval", "--raw", "-A", f"nextcloud-talk-desktop.passthru.hashes.darwin"],
  capture_output=True,
  encoding="locale",
).stdout

newDarwinHash = subprocess.run(
  ["bash", "-c", f"nix store prefetch-file {darwinUrl} --json | jq -r '.hash'"],
  capture_output=True,
  encoding="locale",
).stdout.strip()  # Has a newline

with open(join(dirname(__file__), "package.nix"), "r") as f:
  txt = f.read()

txt = txt.replace(oldDarwinHash, newDarwinHash)

with open(join(dirname(__file__), "package.nix"), "w") as f:
  f.write(txt)
