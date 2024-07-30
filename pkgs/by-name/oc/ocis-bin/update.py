#!/usr/bin/env nix-shell
##!nix-shell -I nixpkgs=./. -i python3 -p common-updater-scripts gnused nix coreutils python312
"""
Updater script for the ocis-bin package.

This script fetches an HTML table from a specified URL and parses it to determine the release type
(either "Rolling" or "Production") of a given software version. It uses the built-in urllib.request
for fetching the HTML content and the built-in html.parser for parsing the HTML. By relying only on
standard library modules, we avoid dependencies on third-party libraries, which simplifies deployment
and improves portability.
"""
import urllib.request
import os
import subprocess
import json
import sys
from datetime import datetime
from html.parser import HTMLParser

TRACKING_CHANNEL = "Production"  # Either Rolling or Production

GITHUB_TOKEN = os.getenv("GITHUB_TOKEN", None)


class TableParser(HTMLParser):
    def __init__(self, version):
        super().__init__()
        self.version = version
        self.in_td = False
        self.current_row = []
        self.release_type = None
        self.in_target_row = False

    def handle_starttag(self, tag, attrs):
        if tag == "td":
            self.in_td = True

        if tag == "a":
            href = dict(attrs).get("href", "")
            if self.version in href:
                self.in_target_row = True

    def handle_endtag(self, tag):
        if tag == "td":
            self.in_td = False

        if tag == "tr" and self.in_target_row:
            self.release_type = self.current_row[1]
            self.in_target_row = False

        if tag == "tr":
            self.current_row = []

    def handle_data(self, data):
        if self.in_td:
            self.current_row.append(data.strip())


def get_release_type(content, version):
    parser = TableParser(version)
    parser.feed(content)
    return parser.release_type


def get_latest_version():
    url = "https://api.github.com/repos/owncloud/ocis/releases?per_page=1"
    req = urllib.request.Request(url)

    if GITHUB_TOKEN:
        req.add_header("Authorization", f"Bearer {GITHUB_TOKEN}")

    with urllib.request.urlopen(req) as response:
        if response.status != 200:
            raise Exception(f"HTTP request failed with status {response.status}")

        data = response.read()
        releases = json.loads(data)
        latest_version = releases[0]["tag_name"].lstrip("v")

    return latest_version


def get_all_versions():
    url = "https://api.github.com/repos/owncloud/ocis/releases"
    req = urllib.request.Request(url)

    if GITHUB_TOKEN:
        req.add_header("Authorization", f"Bearer {GITHUB_TOKEN}")

    with urllib.request.urlopen(req) as response:
        if response.status != 200:
            raise Exception(f"HTTP request failed with status {response.status}")

        data = response.read()
        releases = json.loads(data)

        versions = []
        for release in releases:
            version = release["tag_name"].lstrip("v")
            published_date = datetime.strptime(
                release["published_at"], "%Y-%m-%dT%H:%M:%SZ"
            )
            versions.append({"version": version, "published_date": published_date})

    return versions


def get_current_version():
    result = subprocess.run(
        [
            "nix-instantiate",
            "--eval",
            "-E",
            "with import ./. {}; ocis-bin.version or (lib.getVersion ocis-bin)",
        ],
        capture_output=True,
        text=True,
    )
    result.check_returncode()
    return result.stdout.strip().strip('"')


def get_hash(os_name, arch, version):
    url = f"https://github.com/owncloud/ocis/releases/download/v{version}/ocis-{version}-{os_name}-{arch}"
    result = subprocess.run(
        ["nix-prefetch-url", "--type", "sha256", url], capture_output=True, text=True
    )
    result.check_returncode()
    pkg_hash = result.stdout.strip()
    result = subprocess.run(
        ["nix", "hash", "to-sri", f"sha256:{pkg_hash}"], capture_output=True, text=True
    )
    result.check_returncode()
    return result.stdout.strip()


def update_source_version(pkg_name, version, hash_value, system):
    subprocess.run(
        [
            "update-source-version",
            pkg_name,
            version,
            hash_value,
            f"--system={system}",
            "--ignore-same-version",
        ],
        check=True,
    )


def main():
    all_versions = get_all_versions()
    latest_version = all_versions[0]
    nix_current_version = get_current_version()

    current_version = None
    for version in all_versions:
        if nix_current_version == version["version"]:
            current_version = version
            break

    if not current_version:
        print(
            f"error: cannot find github release for current nix version of ocis-bin {nix_current_version}"
        )
        sys.exit(1)

    if current_version == latest_version:
        print(f"ocis-bin is up-to-date: {current_version}")
        return

    roadmap_url = "https://owncloud.dev/ocis/release_roadmap/"
    response = urllib.request.urlopen(roadmap_url)
    content = response.read().decode("utf-8")
    latest_version_channel = get_release_type(content, latest_version["version"])
    current_version_channel = get_release_type(content, current_version["version"])

    target_version = None
    if latest_version_channel == TRACKING_CHANNEL:
        target_version = latest_version
    elif latest_version_channel != TRACKING_CHANNEL:
        for version in all_versions:
            channel = get_release_type(content, version["version"])
            if (
                channel == TRACKING_CHANNEL
                and version["published_date"] > current_version["published_date"]
            ):
                target_version = version
                print(
                    f"ocis-bin found newer version {version['version']} in channel {TRACKING_CHANNEL}"
                )
                break

    if not target_version:
        print(
            f"ocis-bin could not find newer version in {TRACKING_CHANNEL} than the current {current_version['version']}"
        )
        return

    systems = [
        ("darwin", "arm64", "aarch64-darwin"),
        ("darwin", "amd64", "x86_64-darwin"),
        ("linux", "arm64", "aarch64-linux"),
        ("linux", "arm", "armv7l-linux"),
        ("linux", "amd64", "x86_64-linux"),
        ("linux", "386", "i686-linux"),
    ]

    for os_name, arch, system in systems:
        hash_value = get_hash(os_name, arch, target_version["version"])
        update_source_version("ocis-bin", target_version["version"], hash_value, system)


if __name__ == "__main__":
    main()
