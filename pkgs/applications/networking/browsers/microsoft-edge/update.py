#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.packaging python3Packages.debian

import base64
import textwrap
from urllib import request

from collections import OrderedDict
from debian.deb822 import Packages
from debian.debian_support import Version
from os.path import abspath, dirname

PIN_PATH = dirname(abspath(__file__)) + '/default.nix'

def packages():
    packages_url = 'https://packages.microsoft.com/repos/edge/dists/stable/main/binary-amd64/Packages'
    handle = request.urlopen(packages_url)
    return handle


def latest_packages(packages: bytes):
    latest_packages: OrderedDict[str, Packages] = {}
    for package in Packages.iter_paragraphs(packages, use_apt_pkg=False):
        name: str = package['Package']
        if not name.startswith('microsoft-edge-'):
            continue
        channel = name.replace('microsoft-edge-', '')
        if channel not in latest_packages:
            latest_packages[channel] = package
        else:
            old_package = latest_packages[channel]
            if old_package.get_version() < package.get_version():  # type: ignore
                latest_packages[channel] = package
    return latest_packages


def nix_expressions(latest: dict[str, Packages]):
    channel_strs: list[str] = []
    for channel, package in latest.items():
        print(f"Processing {channel} {package['Version']}")
        match = Version.re_valid_version.match(package['Version'])
        assert match is not None

        version = match.group('upstream_version')
        revision = match.group('debian_revision')
        sri = 'sha256-' + \
            base64.b64encode(bytes.fromhex(package['SHA256'])).decode('ascii')

        channel_str = textwrap.dedent(
            f'''\
            {channel} = import ./browser.nix {{
              channel = "{channel}";
              version = "{version}";
              revision = "{revision}";
              sha256 = "{sri}";
            }};'''
        )
        channel_strs.append(channel_str)
    return channel_strs


def write_expression():
    latest = latest_packages(packages())
    channel_strs = nix_expressions(latest)
    nix_expr = '{\n' + textwrap.indent('\n'.join(channel_strs), '  ') + '\n}\n'
    with open(PIN_PATH, 'w') as f:
        f.write(nix_expr)


write_expression()
