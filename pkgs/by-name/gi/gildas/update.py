#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages (ps: [ ps.beautifulsoup4 ps.requests ])"

"""
Update the gildas package in nixpkgs.

"""

import re
import subprocess
import requests
import os
from bs4 import BeautifulSoup


def to_version(srcVersion):
    """
    Convert the source version to the package version

    This function converts the source version from the format "apr25a"
    to "20250401_a".

    """

    months = {
        "jan": "01",
        "feb": "02",
        "mar": "03",
        "apr": "04",
        "may": "05",
        "jun": "06",
        "jul": "07",
        "aug": "08",
        "sep": "09",
        "oct": "10",
        "nov": "11",
        "dec": "12",
    }

    month = srcVersion[0:3]
    year = srcVersion[3:5]
    revision = srcVersion[5:6]

    return f"20{year}{months[month]}01_{revision}"


def get_srcVersion():
    """
    Get the available source versions from the gildas website

    """

    srcVersions = []
    response = requests.get("https://www.iram.fr/~gildas/dist/index.html")
    soup = BeautifulSoup(response.text, "html.parser")
    pattern = r"^gildas-src-([a-z]{3}\d{2}[a-z])\.tar\.xz$"
    for link in soup.find_all("a"):
        href = link["href"]
        match = re.search(pattern, href)
        if match:
            srcVersions.append(match.group(1))

    return srcVersions


def find_latest(srcVersions):
    """
    Return the latest source version from a list

    """

    latestVersion = ""
    for srcVersion in srcVersions:
        version = to_version(srcVersion)
        if version > latestVersion:
            latest = srcVersion

    return latest


def get_hash(srcVersion):
    """
    Get the hash of a given source versionn

    """

    url = f"http://www.iram.fr/~gildas/dist/gildas-src-{srcVersion}.tar.xz"
    srcHash = subprocess.check_output(["nix-prefetch-url", url]).decode().strip()
    # Convert to SRI representation
    srcSRIHash = (
        subprocess.check_output(["nix-hash", "--to-sri", "--type", "sha256", srcHash])
        .decode()
        .strip()
    )
    return srcSRIHash


def get_package_attribute(attr):
    """
    Get a package attribute

    """

    pattern = attr + r'\s*=\s*"([^"]+)";'
    with open("package.nix", "r") as f:
        for line in f:
            match = re.search(pattern, line)
            if match:
                return match.group(1)


def update_package(srcVersion, version, srcHash):
    """
    Update the package

    """

    current_srcVersion = get_package_attribute("srcVersion")
    current_version = get_package_attribute("version")
    current_hash = get_package_attribute("hash")

    with open("package.nix", "r") as f:
        lines = f.readlines()

    with open("package.nix", "w") as f:
        for line in lines:
            line = line.replace(current_srcVersion, srcVersion)
            line = line.replace(current_version, version)
            line = line.replace(current_hash, srcHash)
            f.write(line)


def main():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))  # allow to run from anywhere
    latest = find_latest(get_srcVersion())
    if latest != get_package_attribute("srcVersion"):
        srcVersion = latest
        version = to_version(srcVersion)
        print(f"Updating gildas to {version}...")
        srcHash = get_hash(srcVersion)
        update_package(srcVersion, version, srcHash)
        print("done")
    else:
        print("Already up to date")


if __name__ == "__main__":
    main()
