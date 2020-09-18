#! /usr/bin/env nix-shell
#! nix-shell -i python -p python3 nix

import csv
import json
import subprocess
import sys

from codecs import iterdecode
from collections import OrderedDict
from os.path import abspath, dirname
from urllib.request import urlopen

HISTORY_URL = 'https://omahaproxy.appspot.com/history?os=linux'
DEB_URL = 'https://dl.google.com/linux/chrome/deb/pool/main/g'
BUCKET_URL = 'https://commondatastorage.googleapis.com/chromium-browser-official'

JSON_PATH = dirname(abspath(__file__)) + '/upstream-info.json'

def load_json(path):
    with open(path, 'r') as f:
        return json.load(f)

def nix_prefetch_url(url, algo='sha256'):
    print(f'nix-prefetch-url {url}')
    out = subprocess.check_output(['nix-prefetch-url', '--type', algo, url])
    return out.decode('utf-8').rstrip()

channels = {}
last_channels = load_json(JSON_PATH)

print(f'GET {HISTORY_URL}', file=sys.stderr)
with urlopen(HISTORY_URL) as resp:
    builds = csv.DictReader(iterdecode(resp, 'utf-8'))
    for build in builds:
        channel_name = build['channel']

        # If we've already found a newer build for this channel, we're
        # no longer interested in it.
        if channel_name in channels:
            continue

        # If we're back at the last build we used, we don't need to
        # keep going -- there's no new version available, and we can
        # just reuse the info from last time.
        if build['version'] == last_channels[channel_name]['version']:
            channels[channel_name] = last_channels[channel_name]
            continue

        channel = {'version': build['version']}
        suffix = 'unstable' if channel_name == 'dev' else channel_name

        try:
            channel['sha256'] = nix_prefetch_url(f'{BUCKET_URL}/chromium-{build["version"]}.tar.xz')
            channel['sha256bin64'] = nix_prefetch_url(f'{DEB_URL}/google-chrome-{suffix}/google-chrome-{suffix}_{build["version"]}-1_amd64.deb')
        except subprocess.CalledProcessError:
            # This build isn't actually available yet.  Continue to
            # the next one.
            continue

        channels[channel_name] = channel

with open(JSON_PATH, 'w') as out:
    def get_channel_key(item):
        channel_name = item[0]
        if channel_name == 'stable':
            return 0
        elif channel_name == 'beta':
            return 1
        elif channel_name == 'dev':
            return 2
        else:
            print(f'Error: Unexpected channel: {channel_name}', file=sys.stderr)
            sys.exit(1)
    sorted_channels = OrderedDict(sorted(channels.items(), key=get_channel_key))
    json.dump(sorted_channels, out, indent=2)
    out.write('\n')
