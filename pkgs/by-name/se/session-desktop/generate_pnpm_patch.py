#!/usr/bin/env python3

import base64
import difflib
import hashlib
import os
import re
import sys
import urllib.request

_, lock_path, patch_path = sys.argv
with open(lock_path, encoding="utf-8") as lockfile:
  original_lines = lockfile.readlines()

tarball_re = re.compile(r"^(\s*resolution: \{)(tarball: )(https://github\.com/[^}\s]+/releases/download/[^}\s]+)(\})")

patched_lines = []
for line in original_lines:
  if match := tarball_re.match(line):
    prefix, tarball, url, suffix = match.groups()
    req = urllib.request.Request(url)
    if 'GITHUB_TOKEN' in os.environ:
      req.add_header('authorization', f'Bearer {os.environ['GITHUB_TOKEN']}')
    data = urllib.request.urlopen(req, timeout=60).read()
    integrity = base64.b64encode(hashlib.sha512(data).digest()).decode()
    line = f"{prefix}integrity: sha512-{integrity}, {tarball}{url}{suffix}\n"
  patched_lines.append(line)

patch = "".join(difflib.unified_diff(
  original_lines,
  patched_lines,
  fromfile="a/pnpm-lock.yaml",
  tofile="b/pnpm-lock.yaml",
  n=0,
))
with open(patch_path, "w", encoding="utf-8", newline="") as patch_file:
  patch_file.write(patch)
