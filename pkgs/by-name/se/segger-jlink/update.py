#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.beautifulsoup4 python3Packages.requests

import requests
import subprocess

from bs4 import BeautifulSoup
from collections import namedtuple
from pathlib import Path
from tempfile import NamedTemporaryFile
from textwrap import indent, dedent


Arch = namedtuple('Architecture', ['os', 'name', 'ext'])
ARCH_MAP = {
    'x86_64-linux': Arch(os='Linux', name='x86_64', ext='tgz'),
    'i686-linux': Arch(os='Linux', name='i386', ext='tgz'),
    'aarch64-linux': Arch(os='Linux', name='arm64', ext='tgz'),
    'armv7l-linux': Arch(os='Linux', name='arm', ext='tgz'),
    'aarch64-darwin': Arch(os='MacOSX', name='arm64', ext='pkg'),
    'x86_64-darwin': Arch(os='MacOSX', name='x86_64', ext='pkg'),
}


def find_latest_jlink_version() -> str:
    try:
        response = requests.get('https://www.segger.com/downloads/jlink/')
        response.raise_for_status()
    except requests.RequestException as e:
        raise RuntimeError(f"Error fetching J-Link version: {e}")

    soup = BeautifulSoup(response.text, 'html.parser')

    jlink_download_tile = soup.find(lambda tag: tag.name == 'tbody' and "J-Link Software and Documentation pack" in tag.text)
    version_select = jlink_download_tile.find('select')
    version = next(o.text for o in version_select.find_all('option'))

    if version is None:
        raise RuntimeError("Could not find the J-Link version on the download page.")

    return version.removeprefix('V').replace('.', '')


def nar_hash(version: str, arch: Arch) -> str:
    '''
    Return the nar hash of 'version' for 'source'.
    '''
    url = f"https://www.segger.com/downloads/jlink/JLink_{arch.os}_V{version}_{arch.name}.{arch.ext}"
    try:
        response = requests.post(url, data={'accept_license_agreement': 'accepted'})
        response.raise_for_status()
    except requests.RequestException as e:
        raise RuntimeError(f"Error downloading file from {url}: {e}")

    with NamedTemporaryFile() as tmpfile:
        tmpfile.write(response.content)
        tmpfile.flush()
        output = subprocess.check_output([
            "nix",
            "--extra-experimental-features", "nix-command",
            "hash", "file", "--sri", tmpfile.name
        ]).decode("utf8")

    return output.strip()


def update_source(version: str):
    content = f'version = "{version}";\n'
    for arch_nix, arch in ARCH_MAP.items():
        nhash = nar_hash(version, arch)
        content += dedent(f'''
        {arch_nix} = {{
          os = "{arch.os}";
          name = "{arch.name}";
          ext = "{arch.ext}";
          hash = "{nhash}";
        }};''').strip() + '\n'

    content = '{\n' + indent(content, '  ') + '}\n'

    with open(Path(__file__).parent / 'source.nix', 'w') as file:
        file.write(content)


if __name__ == '__main__':
    update_source(find_latest_jlink_version())
