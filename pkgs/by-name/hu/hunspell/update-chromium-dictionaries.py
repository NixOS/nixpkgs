#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 nix nix-prefetch-git

import base64
import fileinput
import json
import os
import re
import subprocess
import sys

from urllib.request import urlopen, Request


DICTIONARIES_CHROMIUM_NIX = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'dictionaries-chromium.nix')


def get_latest_chromium_stable_release():
    RELEASES_URL = 'https://versionhistory.googleapis.com/v1/chrome/platforms/linux/channels/stable/versions/all/releases'
    print(f'GET {RELEASES_URL}')
    with urlopen(RELEASES_URL) as resp:
        return json.load(resp)['releases'][0]


def get_file_revision(revision, file_path):
    """Fetches the requested Git revision of the given Chromium file."""
    url = f'https://chromium.googlesource.com/chromium/src/+/refs/tags/{revision}/{file_path}?format=TEXT'
    with urlopen(url) as http_response:
        resp = http_response.read()
        return base64.b64decode(resp)


def nix_prefetch_git(url, rev):
    """Prefetches the requested Git revision of the given repository URL."""
    print(f'nix-prefetch-git {url} {rev}')
    out = subprocess.check_output(['nix-prefetch-git', '--quiet', '--url', url, '--rev', rev])
    return json.loads(out)


def get_current_revision():
    with open(DICTIONARIES_CHROMIUM_NIX) as f:
        for line in f:
            rev = re.search(r'^        rev = "(.*)";', line)
            if rev:
                return rev.group(1)
    sys.exit(1)


print('Getting latest chromium version...')
chromium_release = get_latest_chromium_stable_release()
chromium_version = chromium_release['version']
print(f'chromium version: {chromium_version}')

print('Getting corresponding hunspell_dictionaries commit...')
deps = get_file_revision(chromium_version, 'DEPS')
hunspell_dictionaries_pattern = r"^\s*Var\('chromium_git'\)\s*\+\s*'\/chromium\/deps\/hunspell_dictionaries\.git'\s*\+\s*'@'\s*\+\s*'(\w*)',$"
hunspell_dictionaries_commit = re.search(hunspell_dictionaries_pattern, deps.decode(), re.MULTILINE).group(1)
print(f'hunspell_dictionaries commit: {hunspell_dictionaries_commit}')

current_commit = get_current_revision()
if current_commit == hunspell_dictionaries_commit:
    print('Commit is already packaged, no update needed.')
    sys.exit(0)

print('Commit has changed compared to the current package, updating...')

print('Getting hash of hunspell_dictionaries revision...')
hunspell_dictionaries_git = nix_prefetch_git("https://chromium.googlesource.com/chromium/deps/hunspell_dictionaries", hunspell_dictionaries_commit)
hunspell_dictionaries_hash = hunspell_dictionaries_git['hash']
print(f'hunspell_dictionaries commit hash: {hunspell_dictionaries_hash}')

with fileinput.FileInput(DICTIONARIES_CHROMIUM_NIX, inplace=True) as file:
    for line in file:
        result = re.sub(r'^      version = ".+";', f'      version = "{chromium_version}";', line)
        result = re.sub(r'^        rev = ".*";', f'        rev = "{hunspell_dictionaries_commit}";', result)
        result = re.sub(r'^        hash = ".+";', f'        hash = "{hunspell_dictionaries_hash}";', result)
        print(result, end='')
