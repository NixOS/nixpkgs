#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 nix nix-prefetch-git

import fileinput
import json
import os
import re
import subprocess

from datetime import datetime
from urllib.request import urlopen, Request


DIR = os.path.dirname(os.path.abspath(__file__))
HEADERS = {'Accept': 'application/vnd.github.v3+json'}


def github_api_request(endpoint):
    base_url = 'https://api.github.com/'
    request = Request(base_url + endpoint, headers=HEADERS)
    with urlopen(request) as http_response:
        return json.loads(http_response.read().decode('utf-8'))


def get_commit_date(repo, sha):
    url = f'https://api.github.com/repos/{repo}/commits/{sha}'
    request = Request(url, headers=HEADERS)
    with urlopen(request) as http_response:
        commit = json.loads(http_response.read().decode())
        date = commit['commit']['committer']['date'].rstrip('Z')
        date = datetime.fromisoformat(date).date().isoformat()
        return 'unstable-' + date


def nix_prefetch_git(url, rev):
    """Prefetches the requested Git revision (incl. submodules) of the given repository URL."""
    print(f'nix-prefetch-git {url} {rev}')
    out = subprocess.check_output(['nix-prefetch-git', '--quiet', '--url', url, '--rev', rev, '--fetch-submodules'])
    return json.loads(out)['sha256']


def nix_prefetch_url(url, unpack=False):
    """Prefetches the content of the given URL."""
    print(f'nix-prefetch-url {url}')
    options = ['--type', 'sha256']
    if unpack:
        options += ['--unpack']
    out = subprocess.check_output(['nix-prefetch-url'] + options + [url])
    return out.decode('utf-8').rstrip()


def update_file(relpath, version, sha256, rev=None):
    file_path = os.path.join(DIR, relpath)
    with fileinput.FileInput(file_path, inplace=True) as f:
        for line in f:
            result = line
            result = re.sub(r'^  version = ".+";', f'  version = "{version}";', result)
            result = re.sub(r'^    sha256 = ".+";', f'    sha256 = "{sha256}";', result)
            if rev:
                result = re.sub(r'^    rev = ".*";', f'    rev = "{rev}";', result)
            print(result, end='')


if __name__ == "__main__":
    tdesktop_tag = github_api_request('repos/telegramdesktop/tdesktop/releases/latest')['tag_name']
    tdesktop_version = tdesktop_tag.lstrip('v')
    tdesktop_hash = nix_prefetch_git('https://github.com/telegramdesktop/tdesktop.git', tdesktop_tag)
    update_file('default.nix', tdesktop_version, tdesktop_hash)
    tg_owt_ref = github_api_request('repos/desktop-app/tg_owt/commits/master')['sha']
    tg_owt_version = get_commit_date('desktop-app/tg_owt', tg_owt_ref)
    tg_owt_hash = nix_prefetch_git('https://github.com/desktop-app/tg_owt.git', tg_owt_ref)
    update_file('tg_owt.nix', tg_owt_version, tg_owt_hash, tg_owt_ref)
    tg_owt_ref = github_api_request('repos/desktop-app/tg_owt/commits/master')['sha']
