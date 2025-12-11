#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i python3 -p common-updater-scripts gnused nix coreutils python312
"""
Updater script for the ocis_5-bin package.

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

MAJOR_VERSION = 5
PKG_NAME = f"ocis_{MAJOR_VERSION}-5"

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


def get_all_versions():
    """Get versions from GitHub releases with pagination (up to 10 pages)."""
    versions = []
    page = 1
    max_pages = 10
    per_page = 30

    while page <= max_pages:
        url = f"https://api.github.com/repos/owncloud/ocis/releases?page={page}&per_page={per_page}"
        req = urllib.request.Request(url)

        if GITHUB_TOKEN:
            req.add_header("Authorization", f"Bearer {GITHUB_TOKEN}")

        req.add_header("Accept", "application/vnd.github.v3+json")
        req.add_header("User-Agent", "ocis-bin-updater-script")

        with urllib.request.urlopen(req) as response:
            if response.status != 200:
                raise Exception(f"HTTP request failed with status {response.status}")

            data = response.read()
            releases = json.loads(data)

            if not releases:
                break

            for release in releases:
                version = release["tag_name"].lstrip("v")
                published_date = datetime.strptime(
                    release["published_at"], "%Y-%m-%dT%H:%M:%SZ"
                )
                versions.append({"version": version, "published_date": published_date})

            page += 1

            if len(releases) < per_page:
                break

    if not versions:
        raise Exception("No releases found in GitHub API response")

    return versions


def get_current_version():
    result = subprocess.run(
        [
            "nix-instantiate",
            "--eval",
            "-E",
            f"with import ./. {{}}; {PKG_NAME}.version or (lib.getVersion {PKG_NAME})",
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
    print("Fetching all versions from GitHub API (with pagination)...")
    all_versions = get_all_versions()
    print(f"Found {len(all_versions)} versions across multiple pages")

    if not all_versions:
        print("Error: No versions fetched from GitHub API")
        sys.exit(1)

    # We depend on the fact that versions are sorted reverse chronologically
    for version in all_versions:
        if version["version"].startswith(str(MAJOR_VERSION)):
            latest_version = version
            break
    print(f"Latest version from GitHub: {latest_version['version']}")

    nix_current_version = get_current_version()
    print(f"Current nix version: {nix_current_version}")

    current_version = None
    for version in all_versions:
        if nix_current_version == version["version"]:
            current_version = version
            break

    if not current_version:
        available_versions = [v["version"] for v in all_versions]
        print(
            f"Error: Cannot find GitHub release for current nix version {nix_current_version}"
        )
        print(
            f"Available versions (searched {len(available_versions)} across multiple pages): {', '.join(available_versions[:10])}..."
        )
        sys.exit(1)

    print(f"Found current version {current_version['version']} in GitHub releases")

    if current_version == latest_version:
        print(f"{PKG_NAME} is already up-to-date: {current_version['version']}")
        return

    print("Fetching release roadmap information...")
    roadmap_url = "https://owncloud.dev/ocis/release_roadmap/"
    try:
        response = urllib.request.urlopen(roadmap_url)
        content = response.read().decode("utf-8")

        latest_version_channel = get_release_type(content, latest_version["version"])
        current_version_channel = get_release_type(content, current_version["version"])

        print(
            f"Latest version {latest_version['version']} is in channel: {latest_version_channel}"
        )
        print(
            f"Current version {current_version['version']} is in channel: {current_version_channel}"
        )
    except Exception as e:
        print(f"Warning: Failed to fetch release roadmap information: {e}")
        print("Proceeding with update using latest version")
        latest_version_channel = TRACKING_CHANNEL
        current_version_channel = TRACKING_CHANNEL

    target_version = None
    if latest_version_channel == TRACKING_CHANNEL:
        target_version = latest_version
        print(
            f"Using latest version {latest_version['version']} as it is in the {TRACKING_CHANNEL} channel"
        )
    elif latest_version_channel != TRACKING_CHANNEL:
        print(f"Looking for a newer version in the {TRACKING_CHANNEL} channel...")
        for version in all_versions:
            try:
                channel = get_release_type(content, version["version"])
                if (
                    channel == TRACKING_CHANNEL
                    and version["published_date"] > current_version["published_date"]
                ):
                    target_version = version
                    print(
                        f"{PKG_NAME} found newer version {version['version']} in channel {TRACKING_CHANNEL}"
                    )
                    break
            except Exception as e:
                print(
                    f"Warning: Failed to determine channel for version {version['version']}: {e}"
                )

    if not target_version:
        print(
            f"{PKG_NAME} could not find newer version in {TRACKING_CHANNEL} than the current {current_version['version']}"
        )
        return

    print(
        f"Updating {PKG_NAME} from {current_version['version']} to {target_version['version']}"
    )

    systems = [
        ("darwin", "arm64", "aarch64-darwin"),
        ("darwin", "amd64", "x86_64-darwin"),
        ("linux", "arm64", "aarch64-linux"),
        ("linux", "arm", "armv7l-linux"),
        ("linux", "amd64", "x86_64-linux"),
        ("linux", "386", "i686-linux"),
    ]

    for os_name, arch, system in systems:
        print(f"Calculating hash for {os_name}-{arch}...")
        hash_value = get_hash(os_name, arch, target_version["version"])
        print(f"Updating package for {system}...")
        update_source_version(PKG_NAME, target_version["version"], hash_value, system)

    print(f"Successfully updated {PKG_NAME} to version {target_version['version']}")


if __name__ == "__main__":
    main()
