#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.beautifulsoup4 python3Packages.requests

import requests
import subprocess

from bs4 import BeautifulSoup
from pathlib import Path
from tempfile import NamedTemporaryFile
from textwrap import indent, dedent


ARCH_MAP = {
    'x86_64-linux': 'x86_64',
    'i686-linux': 'i386',
    'aarch64-linux': 'arm64',
    'armv7l-linux': 'arm',
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


def nar_hash(url: str) -> str:
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


def calculate_package_hashes(version: str) -> list[tuple[str, str, str]]:
    result = []
    for (arch_nix, arch_web) in ARCH_MAP.items():
        url = f"https://www.segger.com/downloads/jlink/JLink_Linux_V{version}_{arch_web}.tgz";
        nhash = nar_hash(url)
        result.append((arch_nix, arch_web, nhash))
    return result


def update_source(version: str, package_hashes: list[tuple[str, str, str]]):
    content = f'version = "{version}";\n'
    for arch_nix, arch_web, nhash in package_hashes:
        content += dedent(f'''
        {arch_nix} = {{
          name = "{arch_web}";
          hash = "{nhash}";
        }};''').strip() + '\n'

    content = '{\n' + indent(content, '  ') + '}\n'

    with open(Path(__file__).parent / 'source.nix', 'w') as file:
        file.write(content)


if __name__ == '__main__':
    version = find_latest_jlink_version()
    package_hashes = calculate_package_hashes(version)
    update_source(version, package_hashes)

