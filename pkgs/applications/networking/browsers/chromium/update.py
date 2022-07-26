#! /usr/bin/env nix-shell
#! nix-shell -i python -p python3 nix nix-prefetch-git

"""This script automatically updates chromium, google-chrome, chromedriver, and ungoogled-chromium
via upstream-info.json."""
# Usage: ./update.py [--commit]

import base64
import csv
import json
import re
import subprocess
import sys

from codecs import iterdecode
from collections import OrderedDict
from datetime import datetime
from distutils.version import LooseVersion
from os.path import abspath, dirname
from urllib.request import urlopen

HISTORY_URL = 'https://omahaproxy.appspot.com/history?os=linux'
DEB_URL = 'https://dl.google.com/linux/chrome/deb/pool/main/g'
BUCKET_URL = 'https://commondatastorage.googleapis.com/chromium-browser-official'

JSON_PATH = dirname(abspath(__file__)) + '/upstream-info.json'
UNGOOGLED_FLAGS_PATH = dirname(abspath(__file__)) + '/ungoogled-flags.toml'
COMMIT_MESSAGE_SCRIPT = dirname(abspath(__file__)) + '/get-commit-message.py'


def load_json(path):
    """Loads the given JSON file."""
    with open(path, 'r') as f:
        return json.load(f)


def nix_prefetch_url(url, algo='sha256'):
    """Prefetches the content of the given URL."""
    print(f'nix-prefetch-url {url}')
    out = subprocess.check_output(['nix-prefetch-url', '--type', algo, url])
    return out.decode('utf-8').rstrip()


def nix_prefetch_git(url, rev):
    """Prefetches the requested Git revision of the given repository URL."""
    print(f'nix-prefetch-git {url} {rev}')
    out = subprocess.check_output(['nix-prefetch-git', '--quiet', '--url', url, '--rev', rev])
    return json.loads(out)


def get_file_revision(revision, file_path):
    """Fetches the requested Git revision of the given Chromium file."""
    url = f'https://chromium.googlesource.com/chromium/src/+/refs/tags/{revision}/{file_path}?format=TEXT'
    with urlopen(url) as http_response:
        resp = http_response.read()
        return base64.b64decode(resp)


def get_matching_chromedriver(version):
    """Gets the matching chromedriver version for the given Chromium version."""
    # See https://chromedriver.chromium.org/downloads/version-selection
    build = re.sub('.[0-9]+$', '', version)
    chromedriver_version_url = f'https://chromedriver.storage.googleapis.com/LATEST_RELEASE_{build}'
    with urlopen(chromedriver_version_url) as http_response:
        chromedriver_version = http_response.read().decode()
        def get_chromedriver_url(system):
            return ('https://chromedriver.storage.googleapis.com/' +
                    f'{chromedriver_version}/chromedriver_{system}.zip')
        return {
            'version': chromedriver_version,
            'sha256_linux': nix_prefetch_url(get_chromedriver_url('linux64')),
            'sha256_darwin': nix_prefetch_url(get_chromedriver_url('mac64')),
            'sha256_darwin_aarch64': nix_prefetch_url(get_chromedriver_url('mac64_m1'))
        }


def get_channel_dependencies(version):
    """Gets all dependencies for the given Chromium version."""
    deps = get_file_revision(version, 'DEPS')
    gn_pattern = b"'gn_version': 'git_revision:([0-9a-f]{40})'"
    gn_commit = re.search(gn_pattern, deps).group(1).decode()
    gn = nix_prefetch_git('https://gn.googlesource.com/gn', gn_commit)
    return {
        'gn': {
            'version': datetime.fromisoformat(gn['date']).date().isoformat(),
            'url': gn['url'],
            'rev': gn['rev'],
            'sha256': gn['sha256']
        }
    }


def get_latest_ungoogled_chromium_tag():
    """Returns the latest ungoogled-chromium tag using the GitHub API."""
    api_tag_url = 'https://api.github.com/repos/Eloston/ungoogled-chromium/tags?per_page=1'
    with urlopen(api_tag_url) as http_response:
        tag_data = json.load(http_response)
        return tag_data[0]['name']


def get_latest_ungoogled_chromium_build():
    """Returns a dictionary for the latest ungoogled-chromium build."""
    tag = get_latest_ungoogled_chromium_tag()
    version = tag.split('-')[0]
    return {
        'channel': 'ungoogled-chromium',
        'version': version,
        'ungoogled_tag': tag
    }


def get_ungoogled_chromium_gn_flags(revision):
    """Returns ungoogled-chromium's GN build flags for the given revision."""
    gn_flags_url = f'https://raw.githubusercontent.com/Eloston/ungoogled-chromium/{revision}/flags.gn'
    return urlopen(gn_flags_url).read().decode()


def channel_name_to_attr_name(channel_name):
    """Maps a channel name to the corresponding main Nixpkgs attribute name."""
    if channel_name == 'stable':
        return 'chromium'
    if channel_name == 'beta':
        return 'chromiumBeta'
    if channel_name == 'dev':
        return 'chromiumDev'
    if channel_name == 'ungoogled-chromium':
        return 'ungoogled-chromium'
    print(f'Error: Unexpected channel: {channel_name}', file=sys.stderr)
    sys.exit(1)


def get_channel_key(item):
    """Orders Chromium channels by their name."""
    channel_name = item[0]
    if channel_name == 'stable':
        return 0
    if channel_name == 'beta':
        return 1
    if channel_name == 'dev':
        return 2
    if channel_name == 'ungoogled-chromium':
        return 3
    print(f'Error: Unexpected channel: {channel_name}', file=sys.stderr)
    sys.exit(1)


def print_updates(channels_old, channels_new):
    """Print a summary of the updates."""
    print('Updates:')
    for channel_name in channels_old:
        version_old = channels_old[channel_name]["version"]
        version_new = channels_new[channel_name]["version"]
        if LooseVersion(version_old) < LooseVersion(version_new):
            attr_name = channel_name_to_attr_name(channel_name)
            print(f'- {attr_name}: {version_old} -> {version_new}')


channels = {}
last_channels = load_json(JSON_PATH)


print(f'GET {HISTORY_URL}', file=sys.stderr)
with urlopen(HISTORY_URL) as resp:
    builds = csv.DictReader(iterdecode(resp, 'utf-8'))
    builds = list(builds)
    builds.append(get_latest_ungoogled_chromium_build())
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
        if channel_name == 'dev':
            google_chrome_suffix = 'unstable'
        elif channel_name == 'ungoogled-chromium':
            google_chrome_suffix = 'stable'
        else:
            google_chrome_suffix = channel_name

        try:
            channel['sha256'] = nix_prefetch_url(f'{BUCKET_URL}/chromium-{build["version"]}.tar.xz')
            channel['sha256bin64'] = nix_prefetch_url(
                f'{DEB_URL}/google-chrome-{google_chrome_suffix}/' +
                f'google-chrome-{google_chrome_suffix}_{build["version"]}-1_amd64.deb')
        except subprocess.CalledProcessError:
            if (channel_name == 'ungoogled-chromium' and 'sha256' in channel and
                    build['version'].split('.')[0] == last_channels['stable']['version'].split('.')[0]):
                # Sometimes ungoogled-chromium is updated to a newer tag than
                # the latest stable Chromium version. In this case we'll set
                # sha256bin64 to null and the Nixpkgs code will fall back to
                # the latest stable Google Chrome (only required for
                # Widevine/DRM which is disabled by default):
                channel['sha256bin64'] = None
            else:
                # This build isn't actually available yet.  Continue to
                # the next one.
                continue

        channel['deps'] = get_channel_dependencies(channel['version'])
        if channel_name == 'stable':
            channel['chromedriver'] = get_matching_chromedriver(channel['version'])
        elif channel_name == 'ungoogled-chromium':
            ungoogled_repo_url = 'https://github.com/Eloston/ungoogled-chromium.git'
            channel['deps']['ungoogled-patches'] = {
                'rev': build['ungoogled_tag'],
                'sha256': nix_prefetch_git(ungoogled_repo_url, build['ungoogled_tag'])['sha256']
            }
            with open(UNGOOGLED_FLAGS_PATH, 'w') as out:
                out.write(get_ungoogled_chromium_gn_flags(build['ungoogled_tag']))

        channels[channel_name] = channel


sorted_channels = OrderedDict(sorted(channels.items(), key=get_channel_key))
if len(sys.argv) == 2 and sys.argv[1] == '--commit':
    for channel_name in sorted_channels.keys():
        version_old = last_channels[channel_name]['version']
        version_new = sorted_channels[channel_name]['version']
        if LooseVersion(version_old) < LooseVersion(version_new):
            last_channels[channel_name] = sorted_channels[channel_name]
            with open(JSON_PATH, 'w') as out:
                json.dump(last_channels, out, indent=2)
                out.write('\n')
            attr_name = channel_name_to_attr_name(channel_name)
            commit_message = f'{attr_name}: {version_old} -> {version_new}'
            if channel_name == 'stable':
                body = subprocess.check_output([COMMIT_MESSAGE_SCRIPT, version_new]).decode('utf-8')
                commit_message += '\n\n' + body
            elif channel_name == 'ungoogled-chromium':
                subprocess.run(['git', 'add', UNGOOGLED_FLAGS_PATH], check=True)
            subprocess.run(['git', 'add', JSON_PATH], check=True)
            subprocess.run(['git', 'commit', '--file=-'], input=commit_message.encode(), check=True)
else:
    with open(JSON_PATH, 'w') as out:
        json.dump(sorted_channels, out, indent=2)
        out.write('\n')
    print_updates(last_channels, sorted_channels)
