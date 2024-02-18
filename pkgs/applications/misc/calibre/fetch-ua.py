#!/usr/bin/env nix-shell
#!nix-shell -i python -p python3 nix

import bz2
import subprocess

subprocess.check_call(['nix', 'build', '.#calibre.src'])
from result.setup.browser_data import download_from_calibre_server

raw = download_from_calibre_server(
    'https://code.calibre-ebook.com/ua-popularity')
content = bz2.decompress(raw).decode('utf-8')
with open('ua-popularity.txt', 'w') as f:
    f.write(content)
    # to pass nixpkgs newline check
    f.write('\n')
subprocess.check_call(['rm', 'result'])
