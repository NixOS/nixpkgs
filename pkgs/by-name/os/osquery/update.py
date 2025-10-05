import base64
import json
import re
import subprocess
import sys
import urllib.request

OWNER = 'osquery'
REPO = 'osquery'
OPENSSL_VERSION_PAT = re.compile(r'^set\(OPENSSL_VERSION "(.*)"\)')
OPENSSL_SHA256_PAT = re.compile(r'^set\(OPENSSL_ARCHIVE_SHA256 "(.*)"\)')
INFO_PATH = 'pkgs/by-name/os/osquery/info.json'


def download_str(url):
    return urllib.request.urlopen(url).read().decode('utf-8')


def get_latest_tag():
    latest_url = f'https://api.github.com/repos/{OWNER}/{REPO}/releases/latest'
    return json.loads(download_str(latest_url))['tag_name']


def read_info():
    with open(INFO_PATH, 'r') as f:
        return json.load(f)


def write_info(info):
    with open(INFO_PATH, 'w') as f:
        json.dump(info, f, indent=4, sort_keys=True)
        f.write('\n')


def sha256_hex_to_sri(hex):
    return 'sha256-' + base64.b64encode(bytes.fromhex(hex)).decode()


def openssl_info_from_cmake(cmake):
    version = None
    sha256 = None
    for line in cmake.splitlines():
        if version is None:
            m = OPENSSL_VERSION_PAT.match(line)
            if m is not None:
                version = m.group(1)
        if sha256 is None:
            m = OPENSSL_SHA256_PAT.match(line)
            if m is not None:
                sha256 = m.group(1)
        if version is not None and sha256 is not None:
            break

    if version is None or sha256 is None:
        raise Exception('Failed to extract openssl fetch info')

    return {
        'url': f'https://www.openssl.org/source/openssl-{version}.tar.gz',
        'hash': sha256_hex_to_sri(sha256)
    }


def openssl_info_for_rev(rev):
    url = f'https://raw.githubusercontent.com/{OWNER}/{REPO}/{rev}/libraries/cmake/formula/openssl/CMakeLists.txt'  # noqa: E501
    return openssl_info_from_cmake(download_str(url))


force = len(sys.argv) == 2 and sys.argv[1] == '--force'

latest_tag = get_latest_tag()
print(f'osquery_latest_tag: {latest_tag}')

if not force:
    old_info = read_info()
    if latest_tag == old_info['osquery']['rev']:
        print('latest tag matches existing rev. exiting')
        sys.exit(0)

openssl_fetch_info = openssl_info_for_rev(latest_tag)
print(f'openssl_info: {openssl_fetch_info}')

prefetch = json.loads(subprocess.check_output([
    'nix-prefetch-git',
    '--fetch-submodules',
    '--quiet',
    f'https://github.com/{OWNER}/{REPO}',
    latest_tag
]))

prefetch_hash = prefetch['hash']

github_fetch_info = {
    'owner': OWNER,
    'repo': REPO,
    'rev': latest_tag,
    'hash': prefetch_hash,
    'fetchSubmodules': True
}

print(f'osquery_hash: {prefetch_hash}')

new_info = {
    'osquery': github_fetch_info,
    'openssl': openssl_fetch_info
}

print(f'osquery_info: {new_info}')

write_info(new_info)
