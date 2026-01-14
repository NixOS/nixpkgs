#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.packaging python3Packages.python-debian common-updater-scripts

import os
from collections import OrderedDict
from os.path import abspath, dirname
from urllib import request

from debian.deb822 import Packages
from debian.debian_support import Version

def packages():
    packages_url = "http://deb.stashcat.com/repo01/dists/stashcat-dc/main/binary-amd64/Packages"
    handle = request.urlopen(packages_url)
    return handle


def latest_packages(packages: bytes):
    latest_packages: OrderedDict[str, Packages] = {}
    for package in Packages.iter_paragraphs(packages, use_apt_pkg=False):
        name: str = package["Package"]
        if not name.startswith("stashcat"):
            continue
        channel = "stable" # It's the only channel
        if channel not in latest_packages:
            latest_packages[channel] = package
        else:
            old_package = latest_packages[channel]
            if old_package.get_version() < package.get_version():  # type: ignore
                latest_packages[channel] = package
    return OrderedDict(sorted(latest_packages.items(), key=lambda x: x[0]))


def write_expression():
    latest = latest_packages(packages())
    version = Version.re_valid_version.match(latest["stable"]["Version"]).group(
        "upstream_version"
    )
    #print(f'update-source-version stashcat "{version}"')
    os.system(f'update-source-version stashcat "{version}"')


write_expression()
