#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

from pathlib import Path
import argparse
import urllib.request
import json
import subprocess
import sys
import base64
import os


thisdir = Path(__file__).parent
root = Path(__file__).parent.parent.parent.parent.parent
_GITHUB_TOKEN = os.environ.get('GITHUB_TOKEN', '')


def fetch_json(url: str):
    if _GITHUB_TOKEN and url.startswith('https://api.github.com/'):
        request = urllib.request.Request(url, headers={'Authentication': f'Bearer {_GITHUB_TOKEN}'})
    else:
        request = urllib.request.Request(url)
    with urllib.request.urlopen(request) as handle:
        return json.load(handle)


def last_version():
    tag_name = fetch_json('https://api.github.com/repos/nmstate/nmstate/releases/latest')['tag_name']
    assert tag_name.startswith('v')
    return tag_name[1:]


def github_release(version: str):
    return fetch_json(f'https://api.github.com/repos/nmstate/nmstate/releases/tags/v{version}')


def extract_version_and_hashes():
    cmd = [
        'nix-instantiate',
        '--system',
        'x86_64-linux',
        '--eval',
        '--strict',
        '--json',
        '-E',
        'let pkg = ((import ./.) {}).pkgs.nmstate; in {inherit (pkg) version; srcs = builtins.map (x: {hash = x.hash; url = x.url; }) pkg.srcs;}',
    ]
    return json.loads(subprocess.run(cmd, check=True, stdout=subprocess.PIPE, cwd=root).stdout)


def digest_to_sri(digest: str) -> str:
    algo, hash = digest.split(':', 1)
    b64_hash = base64.b64encode(bytes.fromhex(hash)).decode('ascii')
    return f"{algo}-{b64_hash}"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("version", default=None, nargs='?')
    args = parser.parse_args()
    if args.version is None:
        args.version = last_version()
    pkg = extract_version_and_hashes()
    old_version = pkg['version']
    if old_version == args.version:
        print('nmstate is up to date')
        sys.exit(0)
    print(f"Updating nmstate from {old_version} to {args.version}")
    new_release = github_release(args.version)
    old_hashes = {
        src['url'].rsplit('/', 1)[-1]: src['hash']
        for src in pkg['srcs']
    }
    new_hashes = {
        asset['name'].replace(args.version, old_version): digest_to_sri(asset['digest'])
        for asset in new_release['assets']
    }
    old_content = (thisdir / 'package.nix').read_text()
    new_content = old_content.replace(f'version = "{old_version}"', f'version = "{args.version}"')
    for name, old_hash in old_hashes.items():
        new_content = new_content.replace(old_hash, new_hashes[name])
    (thisdir / 'package.nix').write_text(new_content)
