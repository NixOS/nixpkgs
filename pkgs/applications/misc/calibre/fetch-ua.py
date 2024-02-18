import bz2
import ssl
from urllib.request import urlopen
import subprocess
import json

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
